import Testing
@testable import Domain
@testable import TaskFeature
import Foundation

@MainActor
@Suite("Task ViewModel Unit Tests")
struct TaskViewModelTests {
  @Test func nameChanged() {
    
  }
  
  @Test func priorityLevelChanged() {
    let sut = TaskViewModel()
    
    #expect(sut.task.priorityLevel == .low)
    
    sut.priorityLevelChanged(to: .high)
    
    #expect(sut.task.priorityLevel == .high)
  }
  
  @Test func dueDateChanged() {
    
  }
  
  @Test func saveButtonTapped() {
    
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
    onCancelSpy: @escaping () -> Void = {}
  ) {
    self.init(task: taskMock, onSave: onSaveSpy, onCancel: onCancelSpy)
  }
}

extension TaskState {
  @MainActor static let mock = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
    name: "Hire Mateusz Bąk",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000)
  )
}

