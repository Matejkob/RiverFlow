public enum TaskSortOrder: String, CaseIterable, Identifiable, Hashable, Equatable, Sendable {
  case creationDateAscending
  case creationDateDescending
  case dueDateAscending
  case dueDateDescending
  case priorityAscending
  case priorityDescending
  
  public var id: Self { self }
}
