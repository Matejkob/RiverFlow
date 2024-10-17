public enum TaskSortOrder: CaseIterable, Identifiable, Hashable, Equatable {
  case creationDateAscending
  case creationDateDescending
  case dueDateAscending
  case dueDateDescending
  case priorityAscending
  case priorityDescending
  
  public var id: Self { self }
}
