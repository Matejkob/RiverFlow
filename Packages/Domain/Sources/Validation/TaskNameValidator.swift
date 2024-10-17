public protocol TaskNameValidatorProtocol {
  func validate(_ input: String) -> ValidationResult
}

public struct TaskNameValidator: TaskNameValidatorProtocol, Validator {
  public init() {}
  
  public func validate(_ input: String) -> ValidationResult {
    input.isEmpty ? .failure("Task name cannot be empty.") : .success
  }
}
