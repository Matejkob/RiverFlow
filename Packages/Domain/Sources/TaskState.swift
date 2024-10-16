import Foundation

public struct TaskState: Equatable, Hashable, Identifiable {
  public let id: UUID
  public var name: String
  public var priorityLevel: TaskPiorityLevel
  public var status: TaskStatus
  public var dueDate: Date
  
  public init(
    id: UUID,
    name: String,
    priorityLevel: TaskPiorityLevel,
    status: TaskStatus,
    dueDate: Date
  ) {
    self.id = id
    self.name = name
    self.priorityLevel = priorityLevel
    self.status = status
    self.dueDate = dueDate
  }
}
