@testable import Domain

class TaskNameValidatorSpy: TaskNameValidatorProtocol {
  var callsCount = 0
  var recivedArguments: [String] = []
  var returnType: () -> ValidationResult = { fatalError() }
  
  func validate(_ input: String) -> ValidationResult {
    callsCount += 1
    recivedArguments.append(input)
    return returnType()
  }
}
