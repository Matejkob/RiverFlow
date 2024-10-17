import Domain
import Foundation
import TaskRepository

public final actor InMemoryTaskRepository: TaskRepository {
  private var tasks: [TaskState] = Mocks.tasks
  private var categories: [TaskCategory] = []
  
  public init() {}
  
  init(tasks: [TaskState], categories: [TaskCategory] = []) {
    self.tasks = tasks
    self.categories = categories
  }
  
  public func fetchAllTasks(
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState] {
    var filteredTasks = tasks
    
    if let filterBy {
      filteredTasks = filteredTasks.filter { $0.priorityLevel == filterBy }
    }
    
    switch sortBy {
    case .creationDateAscending:
      filteredTasks.sort { $0.creationDate < $1.creationDate }
    case .creationDateDescending:
      filteredTasks.sort { $0.creationDate > $1.creationDate }
    case .dueDateAscending:
      filteredTasks.sort { $0.dueDate < $1.dueDate }
    case .dueDateDescending:
      filteredTasks.sort { $0.dueDate > $1.dueDate }
    case .priorityAscending:
      filteredTasks.sort { $0.priorityLevel.rawValue < $1.priorityLevel.rawValue }
    case .priorityDescending:
      filteredTasks.sort { $0.priorityLevel.rawValue > $1.priorityLevel.rawValue }
    }
    
    return filteredTasks
  }
  
  public func fetchAllCategories() async throws -> [TaskCategory] {
    categories
  }
  
  public func fetchTasks(
    for category: TaskCategory,
    sortBy: TaskSortOrder,
    filterBy: TaskPiorityLevel?
  ) async throws -> [TaskState] {
    var filteredTasks = tasks.filter { $0.category?.id == category.id }
    
    if let filterBy {
      filteredTasks = filteredTasks.filter { $0.priorityLevel == filterBy }
    }
    
    switch sortBy {
    case .creationDateAscending:
      filteredTasks.sort { $0.creationDate < $1.creationDate }
    case .creationDateDescending:
      filteredTasks.sort { $0.creationDate > $1.creationDate }
    case .dueDateAscending:
      filteredTasks.sort { $0.dueDate < $1.dueDate }
    case .dueDateDescending:
      filteredTasks.sort { $0.dueDate > $1.dueDate }
    case .priorityAscending:
      filteredTasks.sort { $0.priorityLevel.rawValue < $1.priorityLevel.rawValue }
    case .priorityDescending:
      filteredTasks.sort { $0.priorityLevel.rawValue > $1.priorityLevel.rawValue }
    }
    
    return filteredTasks
  }
  
  public func saveTask(_ task: TaskState) async throws {
    tasks.append(task)
  }
  
  public func saveCategory(_ category: TaskCategory) async throws {
    categories.append(category)
  }
  
  public func updateTask(_ task: TaskState) async throws {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks[index] = task
    }
  }
  
  public func deleteTask(_ task: TaskState) async throws {
    tasks.removeAll(where: { $0.id == task.id })
  }
}

extension TaskRepository where Self == InMemoryTaskRepository {
  public static var inMemory: TaskRepository { InMemoryTaskRepository() }
}

// MARK: Mocks
// This code is used in previews and unit tests.
// We could hide this behind DEBUG preprocessor flag.

private enum Mocks {
  static let tasks =  [
    TaskState(
      id: UUID(),
      name: "Task 3",
      priorityLevel: .high,
      status: .inProgress,
      dueDate: Date() + 60 * 4,
      creationDate: Date() - 60,
      category: TaskCategory(id: UUID(), name: "Work")
    ),
    TaskState(
      id: UUID(),
      name: "Task 3.1",
      priorityLevel: .medium,
      status: .inProgress,
      dueDate: Date() + 60 * 7,
      creationDate: Date() - 60,
      category: TaskCategory(id: UUID(), name: "Work")
    ),
    TaskState(
      id: UUID(),
      name: "Task 2",
      priorityLevel: .medium,
      status: .inProgress,
      dueDate: Date() + 60 * 2,
      creationDate: Date() - 60 * 2,
      category: TaskCategory(id: UUID(), name: "Personal")
    ),
    TaskState(
      id: UUID(),
      name: "Task 2.1",
      priorityLevel: .low,
      status: .inProgress,
      dueDate: Date() + 60 * 20,
      creationDate: Date() - 60 * 2,
      category: TaskCategory(id: UUID(), name: "Work")
    ),
    TaskState(
      id: UUID(),
      name: "Task 1",
      priorityLevel: .low,
      status: .inProgress,
      dueDate: Date() + 60 * 100,
      creationDate: Date() - 60 * 3,
      category: TaskCategory(id: UUID(), name: "Personal")
    ),
    TaskState(
      id: UUID(),
      name: "Task 1.1",
      priorityLevel: .high,
      status: .inProgress,
      dueDate: Date() + 60 * 3,
      creationDate: Date() - 60 * 3,
      category: nil
    )
  ]
}
