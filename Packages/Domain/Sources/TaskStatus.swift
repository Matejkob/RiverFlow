import Foundation

public enum TaskStatus: Equatable, Hashable, Sendable {
  case pending
  case inProgress
  case completed(completionDate: Date)
  case removed
}
