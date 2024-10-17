import Testing
@testable import Domain
import Foundation

@Suite("Task Due Date Validator Unit Tests")
struct TaskDueDateValidatorTests {
  @Test func dueDateValidator_withPastDate_fails() {
    let now = Date(timeIntervalSince1970: 500_000_000)
    let pastDate = Date(timeIntervalSince1970: 100_000)
    
    let sut = TaskDueDateValidator(now: { now })
    
    let result = sut.validate(pastDate)
    
    #expect(result == .failure("Due date cannot be in the past."))
  }
  
  @Test func dueDateValidator_withFutureDate_succeeds() {
    let now = Date(timeIntervalSince1970: 500_000_000)
    let futureDate = Date(timeIntervalSince1970: 600_000_000)
    
    let sut = TaskDueDateValidator(now: { now })
    
    let result = sut.validate(futureDate)
    
    #expect(result == .success)
  }
  
  @Test func dueDateValidator_withCurrentDate_succeeds() {
    let now = Date(timeIntervalSince1970: 500_000_000)
    
    let sut = TaskDueDateValidator(now: { now })
    
    let result = sut.validate(now)
    
    #expect(result == .success)
  }
}
