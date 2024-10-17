import Testing
@testable import Domain

@Suite("Task Name Validator Unit Tests")
struct TaskNameValidatorTests {
  @Test func nameValidator_withEmptyName_fails() {
    let sut = TaskNameValidator()
    
    let result = sut.validate("")
    
    #expect(result == .failure("Task name cannot be empty."))
  }
  
  @Test func nameValidator_withValidName_succeeds() {
    let sut = TaskNameValidator()
    
    let result = sut.validate("Write Unit Tests")
    
    #expect(result == .success)
  }
}
