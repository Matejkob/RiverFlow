import Foundation

public enum TaskPiorityLevel: Int, CaseIterable, Identifiable, Equatable, Hashable, Sendable {
  case low
  case medium
  case high
  
  public var id: Self { self }
}
