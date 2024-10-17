import Foundation

public enum TaskStatus: CaseIterable, Identifiable, Equatable, Hashable, Sendable {
  case pending
  case inProgress
  case completed
  
  public var id: Self { self }
}
