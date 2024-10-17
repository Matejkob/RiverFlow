import Testing
@testable import Domain
@testable import TaskFeature
import Foundation

@MainActor
@Suite("Task ViewModel Unit Tests")
struct TaskViewModelTests {
  @Test func nameChanged_create() {
    let emptyTaskMock = TaskState(
      id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
      name: "",
      priorityLevel: .low,
      status: .inProgress,
      dueDate: Date(timeIntervalSince1970: 1_000),
      creationDate: Date(timeIntervalSince1970: 0),
      category: nil
    )
    let sut = TaskViewModel(taskMock: emptyTaskMock)
    
    sut.nameChanged(to: "Make sure this test passes")
    
    #expect(sut.task.name == "Make sure this test passes")
  }
  
  @Test func nameChanged_edit() {
    let taskMock = TaskState.mock
    let sut = TaskViewModel(taskMock: taskMock)
    
    sut.nameChanged(to: "It's a new name")
    
    #expect(sut.task.name == "It's a new name")
  }
  
  @Test func priorityLevelChanged() {
    let sut = TaskViewModel()
    
    #expect(sut.task.priorityLevel == .low)
    
    sut.priorityLevelChanged(to: .high)
    
    #expect(sut.task.priorityLevel == .high)
  }
  
  @Test func dueDateChanged() {
    let taskMock = TaskState.mock
    let sut = TaskViewModel(taskMock: taskMock)
    
    sut.dueDateChanged(to: Date(timeIntervalSince1970: 123_456_789))
    
    #expect(sut.task.dueDate == Date(timeIntervalSince1970: 123_456_789))
  }
  
  @Test func saveButtonTapped_whenNameValidationFails() async {
    let taskNameValidatorSpy = TaskNameValidatorSpy()
    taskNameValidatorSpy.returnType = { .failure("name error message") }
    let taskDueDateValidatorSpy = TaskDueDateValidatorSpy()
    taskDueDateValidatorSpy.returnType = { .success }
    
    let sut = TaskViewModel(
      taskNameValidatorSpy: taskNameValidatorSpy,
      taskDueDateValidatorSpy: taskDueDateValidatorSpy
    )
    
    await sut.saveButtonTapped()
    
    #expect(sut.destination == .validationAlert(message: "name error message"))
  }
  
  @Test func saveButtonTapped_whenDueDateValidationFails() async {
    let taskNameValidatorSpy = TaskNameValidatorSpy()
    taskNameValidatorSpy.returnType = { .success }
    let taskDueDateValidatorSpy = TaskDueDateValidatorSpy()
    taskDueDateValidatorSpy.returnType = { .failure("due date error message") }
    
    let sut = TaskViewModel(
      taskNameValidatorSpy: taskNameValidatorSpy,
      taskDueDateValidatorSpy: taskDueDateValidatorSpy
    )
    
    await sut.saveButtonTapped()
    
    #expect(sut.destination == .validationAlert(message: "due date error message"))
  }
  
  @Test func saveButtonTapped_whenBothValidationsFail() async {
    let taskNameValidatorSpy = TaskNameValidatorSpy()
    taskNameValidatorSpy.returnType = { .failure("name error message") }
    let taskDueDateValidatorSpy = TaskDueDateValidatorSpy()
    taskDueDateValidatorSpy.returnType = { .failure("due date error message") }
    
    let sut = TaskViewModel(
      taskNameValidatorSpy: taskNameValidatorSpy,
      taskDueDateValidatorSpy: taskDueDateValidatorSpy
    )
    
    await sut.saveButtonTapped()
    
    #expect(sut.destination == .validationAlert(message: "name error message"))
  }
  
  @Test func saveButtonTapped_whenAllValidationsSucceed() async {
    let taskNameValidatorSpy = TaskNameValidatorSpy()
    taskNameValidatorSpy.returnType = { .success }
    let taskDueDateValidatorSpy = TaskDueDateValidatorSpy()
    taskDueDateValidatorSpy.returnType = { .success }
    
    var wasOnSaveCalled = false
    let sut = TaskViewModel(
      onSaveSpy: { _ in
        wasOnSaveCalled = true
      },
      taskNameValidatorSpy: taskNameValidatorSpy,
      taskDueDateValidatorSpy: taskDueDateValidatorSpy
    )
    
    await sut.saveButtonTapped()
    
    #expect(sut.destination == nil)
    #expect(wasOnSaveCalled == true)
  }
  
  @Test func cancelButtonTapped() {
    var wasOnCanelCalled = false
    
    let sut = TaskViewModel(
      onCancelSpy: {
        wasOnCanelCalled = true
      }
    )
    
    sut.cancelButtonTapped()
    
    #expect(wasOnCanelCalled == true)
  }
}

// MARK: - Helpers

extension TaskViewModel {
  convenience init(
    taskMock: TaskState = .mock,
    onSaveSpy: @escaping (TaskState) -> Void = { _ in },
    onCancelSpy: @escaping () -> Void = {},
    taskNameValidatorSpy: TaskNameValidatorProtocol = TaskNameValidatorSpy(),
    taskDueDateValidatorSpy: TaskDueDateValidatorProtocol = TaskDueDateValidatorSpy()
  ) {
    self.init(
      task: taskMock,
      onSave: onSaveSpy,
      onCancel: onCancelSpy,
      taskNameValidator: taskNameValidatorSpy,
      taskDueDateValidator: taskDueDateValidatorSpy
    )
  }
}

extension TaskState {
  @MainActor static let mock = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
    name: "Hire Mateusz Bąk",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000),
    category: nil
  )
}

