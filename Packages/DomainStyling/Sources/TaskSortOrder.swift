import Domain

extension TaskSortOrder {
  public var name: String {
    switch self {
    case .creationDateAscending:
      "Creation Date Ascending"
    case .creationDateDescending:
      "Creation Date Descending"
    case .dueDateAscending:
      "Due Date Ascending"
    case .dueDateDescending:
      "Due Date Descending"
    case .priorityAscending:
      "Priority Ascending"
    case .priorityDescending:
      "Priority Descending"
    }
  }
}
