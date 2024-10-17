@testable import Domain
import Foundation

class TaskDueDateValidatorSpy: TaskDueDateValidatorProtocol {
  var callsCount = 0
  var recivedArguments: [Date] = []
  var returnType: () -> ValidationResult = { fatalError() }
  
  func validate(_ input: Date) -> ValidationResult {
    callsCount += 1
    recivedArguments.append(input)
    return returnType()
  }
}
