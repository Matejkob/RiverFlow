public protocol Validator {
  associatedtype Input
  func validate(_ input: Input) -> ValidationResult
}
