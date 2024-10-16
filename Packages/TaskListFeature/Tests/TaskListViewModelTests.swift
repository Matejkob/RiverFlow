import Testing
@testable import Domain
@testable import TaskListFeature
import Foundation

@MainActor
@Suite("Task List View Model Unit Tests")
struct TaskListViewModelTests {
  @Test func addNewButtonTapped() {
    let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    let now = Date(timeIntervalSince1970: 0)
    let sut = TaskListViewModel(
      uuid: { uuid },
      now: { now }
    )
    
    sut.addNewButtonTapped()
    
    #expect(
      sut.destination == .add(
        TaskState(
          id: uuid,
          name: "",
          priorityLevel: .low,
          status: .pending,
          dueDate: now + 60 * 60 * 24
        )
      )
    )
  }
  
  @Test func saveNewTaskButtonTapped() {
    let task = TaskState.mock
    let sut = TaskListViewModel(tasks: [])
    
    sut.saveNewTaskButtonTapped(task)
    
    #expect(sut.tasks.count == 1)
    #expect(sut.tasks.first == task)
    #expect(sut.destination == nil)
  }
  
  @Test func cancelAddingNewTaskButtonTapped() {
    let sut = TaskListViewModel(destination: .add(TaskState.mock))
    
    sut.cancelAddingNewTaskButtonTapped()
    
    #expect(sut.destination == nil)
  }
}

// MARK: - Helpers

extension TaskState {
  @MainActor static let mock = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
    name: "Hire Mateusz Bąk",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000)
  )
  
  @MainActor static let mock2 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
    name: "TODO: Fix UI",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000)
  )
  
  @MainActor static let mock3 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
    name: "FIXME: Implement modular navigation",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000)
  )
}
