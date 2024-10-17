import Domain
import Foundation
import TaskRepository
import GRDB

public final class GRDBTaskRepository: TaskRepository, Sendable {
  private let databaseQueue: DatabaseQueue
  
  init(databaseQueue: DatabaseQueue) throws {
    self.databaseQueue = databaseQueue
    
    try databaseQueue.write { db in
      // Create categories table if not exists
      try db.create(table: "categories", ifNotExists: true) { t in
        t.column("id", .text).primaryKey()
        t.column("name", .text).notNull()
      }
      
      // Create tasks table if not exists, with foreign key to categories table
      try db.create(table: "tasks", ifNotExists: true) { t in
        t.column("id", .text).primaryKey()
        t.column("name", .text).notNull()
        t.column("priorityLevel", .integer).notNull()
        t.column("status", .integer).notNull()
        t.column("dueDate", .datetime).notNull()
        t.column("reminderTime", .double)
        t.column("creationDate", .datetime).notNull()
        t.column("categoryId", .text).references("categories", onDelete: .setNull)
        t.column("categoryName", .text)
        t.column("completionDate", .datetime) // Nullable for `TaskStatus.completed`
      }
    }
  }
  
  public func fetchAllTasks(
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState] {
    try await databaseQueue.read { db in
      var sql = "SELECT * FROM tasks"
      var arguments: StatementArguments = []
      
      if let filterBy = filterBy {
        sql += " WHERE priorityLevel = ?"
        _ = arguments.append(contentsOf: [filterBy.rawValue])
      }
      
      switch sortBy {
      case .creationDateAscending:
        sql += " ORDER BY creationDate ASC"
      case .creationDateDescending:
        sql += " ORDER BY creationDate DESC"
      case .dueDateAscending:
        sql += " ORDER BY dueDate ASC"
      case .dueDateDescending:
        sql += " ORDER BY dueDate DESC"
      case .priorityAscending:
        sql += " ORDER BY priorityLevel ASC"
      case .priorityDescending:
        sql += " ORDER BY priorityLevel DESC"
      }
      
      let rows = try Row.fetchAll(db, sql: sql, arguments: arguments)
      return rows.compactMap { Self.taskState(from: $0) }
    }
  }
  
  public func fetchAllCategories() async throws -> [TaskCategory] {
    return try await databaseQueue.read { db in
      let rows = try Row.fetchAll(db, sql: "SELECT * FROM categories")
      return rows.compactMap { row in
        guard let id = UUID(uuidString: row["id"]) else { return nil }
        return TaskCategory(id: id, name: row["name"] )
      }
    }
  }
  
  public func fetchTasks(
    for category: TaskCategory,
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState] {
    return try await databaseQueue.read { db in
      var sql = "SELECT * FROM tasks WHERE categoryId = ?"
      var arguments: StatementArguments = [category.id.uuidString]
      
      if let filterBy = filterBy {
        sql += " AND priorityLevel = ?"
        _ = arguments.append(contentsOf: [filterBy.rawValue])
      }
      
      switch sortBy {
      case .creationDateAscending:
        sql += " ORDER BY creationDate ASC"
      case .creationDateDescending:
        sql += " ORDER BY creationDate DESC"
      case .dueDateAscending:
        sql += " ORDER BY dueDate ASC"
      case .dueDateDescending:
        sql += " ORDER BY dueDate DESC"
      case .priorityAscending:
        sql += " ORDER BY priorityLevel ASC"
      case .priorityDescending:
        sql += " ORDER BY priorityLevel DESC"
      }
      
      let rows = try Row.fetchAll(db, sql: sql, arguments: arguments)
      return rows.compactMap { Self.taskState(from: $0) }
    }
  }
  
  public func saveTask(_ task: TaskState) async throws {
    try await databaseQueue.write { db in
      try Self.save(task: task, in: db)
    }
  }
  
  public func saveCategory(_ category: TaskCategory) async throws {
    try await databaseQueue.write { db in
      try db.execute(
        sql: """
        INSERT OR REPLACE INTO categories (id, name)
        VALUES (?, ?)
        """,
        arguments: [category.id.uuidString, category.name]
      )
    }
  }
  
  public func updateTask(_ task: TaskState) async throws {
    try await databaseQueue.write { db in
      try Self.save(task: task, in: db)
    }
  }
  
  public func deleteTask(_ task: TaskState) async throws {
    try await databaseQueue.write { db in
      try db.execute(sql: "DELETE FROM tasks WHERE id = ?", arguments: [task.id.uuidString])
    }
  }
  
  // MARK: - TaskState Mapping
  
  private static func taskState(from row: Row) -> TaskState? {
    let status: TaskStatus
    if let completionDate = row["completionDate"] as? Date {
      status = .completed(completionDate: completionDate)
    } else if row["status"] == 0 {
      status = .pending
    } else if row["status"] == 1 {
      status = .inProgress
    } else {
      status = .removed
    }
    
    let category: TaskCategory?
    if let categoryId = row["categoryId"] as? String,
       let categoryName = row["categoryName"] as? String,
       let id = UUID(uuidString: categoryId) {
      category = TaskCategory(id: id, name: categoryName)
    } else {
      category = nil
    }
    
    guard let id = UUID(uuidString: row["id"]),
          let priorityLevel = TaskPiorityLevel(rawValue: row["priorityLevel"]) else {
      return nil
    }
    
    return TaskState(
      id: id,
      name: row["name"],
      priorityLevel: priorityLevel,
      status: status,
      reminderTime: row["reminderTime"] as? TimeInterval,
      dueDate: row["dueDate"],
      creationDate: row["creationDate"],
      category: category
    )
  }
  
  private static func save(task: TaskState, in db: Database) throws {
    let statusValue: Int
    let completionDate: Date?
    
    switch task.status {
    case .pending:
      statusValue = 0
      completionDate = nil
    case .inProgress:
      statusValue = 1
      completionDate = nil
    case .completed(let date):
      statusValue = 2
      completionDate = date
    case .removed:
      statusValue = 3
      completionDate = nil
    }
    
    let categoryId = task.category?.id.uuidString
    let categoryName = task.category?.name
    
    try db.execute(
      sql: """
       INSERT OR REPLACE INTO tasks (id, name, priorityLevel, status, dueDate, reminderTime, creationDate, categoryId, categoryName, completionDate)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
       """,
      arguments: [
        task.id.uuidString,
        task.name,
        task.priorityLevel.rawValue,
        statusValue,
        task.dueDate,
        task.reminderTime,
        task.creationDate,
        categoryId,
        categoryName,
        completionDate
      ]
    )
  }
}

extension TaskRepository where Self == GRDBTaskRepository {
  public static var GRDB: TaskRepository {
    do {
      let fileManager = FileManager.default
      let appSupportURL = try fileManager.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      let directoryURL = appSupportURL.appendingPathComponent("TasksDatabase", isDirectory: true)
      try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
      let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
      let databaseQueue = try DatabaseQueue(path: databaseURL.path)
      
      let repository = try GRDBTaskRepository(databaseQueue: databaseQueue)
      
      return repository
    } catch {
      fatalError("Unresolved error \(error)")
    }
  }
}
