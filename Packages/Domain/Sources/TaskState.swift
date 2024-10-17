import Foundation

public struct TaskState: Equatable, Hashable, Identifiable, Sendable {
  public let id: UUID
  public var name: String
  public var priorityLevel: TaskPiorityLevel
  public var status: TaskStatus
  public var dueDate: Date
  public let creationDate: Date
  public var category: TaskCategory?
  
  public init(
    id: UUID,
    name: String,
    priorityLevel: TaskPiorityLevel,
    status: TaskStatus,
    dueDate: Date,
    creationDate: Date,
    category: TaskCategory?
  ) {
    self.id = id
    self.name = name
    self.priorityLevel = priorityLevel
    self.status = status
    self.dueDate = dueDate
    self.creationDate = creationDate
    self.category = category
  }
}
