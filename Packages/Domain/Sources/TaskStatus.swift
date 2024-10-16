import Foundation

public enum TaskStatus: Equatable, Hashable {
  case pending
  case inProgress
  case completed(completionDate: Date)
  case removed
}
