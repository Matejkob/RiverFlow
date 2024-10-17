import Testing
@testable import Domain
@testable import TaskListFeature
import Foundation

@MainActor
@Suite("Task List ViewModel Unit Tests")
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
          dueDate: now + 60 * 60 * 24,
          creationDate: now
        )
      )
    )
  }
  
  @Test func taskTapped() {
    let task = TaskState.mock
    let sut = TaskListViewModel(tasks: [task])
    
    sut.taskTapped(task)
    
    #expect(sut.destination == .edit(task))
  }
  
  @Test func deleteTask() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.deleteTask(at: [1])
    
    #expect(sut.filteredTasks.count == 2)
    #expect(sut.filteredTasks == [.mock, .mock3])
  }
  
  @Test func deleteTasksRange() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])

    sut.deleteTask(at: [0, 2])
    
    #expect(sut.filteredTasks.count == 1)
    #expect(sut.filteredTasks == [.mock2])
  }
  
  @Test func saveNewTaskButtonTapped() {
    let task = TaskState.mock
    let sut = TaskListViewModel(tasks: [])
    
    sut.saveNewTaskButtonTapped(task)
    
    #expect(sut.filteredTasks.count == 1)
    #expect(sut.filteredTasks.first == task)
    #expect(sut.destination == nil)
  }
  
  @Test func cancelAddingNewTaskButtonTapped() {
    let sut = TaskListViewModel(destination: .add(TaskState.mock))
    
    sut.cancelAddingNewTaskButtonTapped()
    
    #expect(sut.destination == nil)
  }
  
  @Test func updateTaskButtonTapped() {
    let task = TaskState.mock
    let updatedTask = TaskState(
        id: task.id,
        name: "Updated Task",
        priorityLevel: .high,
        status: .inProgress,
        dueDate: Date(timeIntervalSince1970: 1_000_555_555),
        creationDate: Date(timeIntervalSince1970: 850_000_000)
    )
    
    let sut = TaskListViewModel(
      tasks: [.mock2, task, .mock3]
    )
    
    sut.updateTaskButtonTapped(updatedTask)
    
    #expect(sut.filteredTasks.count == 3)
    #expect(sut.filteredTasks == [.mock2, updatedTask, .mock3])
    #expect(sut.destination == nil)
  }
  
  @Test func cancelEditingTaskButtonTapped() {
    let sut = TaskListViewModel(destination: .edit(TaskState.mock))
    
    sut.cancelEditingTaskButtonTapped()
    
    #expect(sut.destination == nil)
  }

  // MARK: - Sorting Tests
  
  @Test func changeSortOrderToDueDateAscending() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changeSortOrder(to: .dueDateAscending)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changeSortOrderToDueDateDescending() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changeSortOrder(to: .dueDateDescending)
    
    #expect(sut.filteredTasks == [.mock3, .mock2, .mock])
  }
  
  @Test func changeSortOrderToPriorityAscending() {
    let task1 = TaskState.mock // Low
    let task2 = TaskState.mockHighPriority
    let task3 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(tasks: [task1, task2, task3])
    
    sut.changeSortOrder(to: .priorityAscending)
    
    #expect(sut.filteredTasks == [task1, task3, task2])
  }
  
  @Test func changeSortOrderToPriorityDescending() {
    let task1 = TaskState.mock // Low
    let task2 = TaskState.mockHighPriority
    let task3 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(tasks: [task1, task2, task3])
    
    sut.changeSortOrder(to: .priorityDescending)
    
    #expect(sut.filteredTasks == [task2, task3, task1])
  }
  
  @Test func changeSortOrderToCreationDateAscending() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changeSortOrder(to: .creationDateAscending)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changeSortOrderToCreationDateDescending() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changeSortOrder(to: .creationDateDescending)
    
    #expect(sut.filteredTasks == [.mock3, .mock2, .mock])
  }
  
  // MARK: - Filtering Tests
  
  @Test func changePriorityLevelFilter() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changePriorityLevelFilter(to: .low)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changePriorityLevelFilterToHigh() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changePriorityLevelFilter(to: .high)
    
    #expect(sut.filteredTasks.isEmpty)
  }
  
  @Test func changePriorityLevelFilterToMedium() {
    let task1 = TaskState.mock
    let task2 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(tasks: [task1, task2, .mock3])
    
    sut.changePriorityLevelFilter(to: .medium)
    
    #expect(sut.filteredTasks == [task2])
  }
  
  @Test func clearPriorityLevelFilter() {
    let sut = TaskListViewModel(tasks: [.mock, .mock2, .mock3])
    
    sut.changePriorityLevelFilter(to: .low)
    
    sut.changePriorityLevelFilter(to: nil)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
}

// MARK: - Helpers

extension TaskState {
  @MainActor static let mock = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
    name: "Hire Mateusz Bąk",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 700_000_000)
  )
  
  @MainActor static let mock2 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
    name: "TODO: Fix UI",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_100_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000)
  )
  
  @MainActor static let mock3 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
    name: "FIXME: Implement modular navigation",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_200_000_000),
    creationDate: Date(timeIntervalSince1970: 900_000_000)
  )

  @MainActor static let mockHighPriority = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
    name: "High Priority Task",
    priorityLevel: .high,
    status: .pending,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000)
  )

  @MainActor static let mockMediumPriority = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
    name: "Medium Priority Task",
    priorityLevel: .medium,
    status: .pending,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 900_000_000)
  )
}
