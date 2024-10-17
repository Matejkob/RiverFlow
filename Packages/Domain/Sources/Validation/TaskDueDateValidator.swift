import Foundation

public protocol TaskDueDateValidatorProtocol {
  func validate(_ input: Date) -> ValidationResult
}

public struct TaskDueDateValidator: TaskDueDateValidatorProtocol, Validator {
  private let now: () -> Date
  
  public init(now: @escaping () -> Date = { Date.now }) {
    self.now = now
  }
  
  public func validate(_ input: Date) -> ValidationResult {
    input < now() ? .failure("Due date cannot be in the past.") : .success
  }
}
