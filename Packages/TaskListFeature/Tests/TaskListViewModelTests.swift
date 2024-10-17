import Testing
@testable import Domain
@testable import TaskListFeature
import Foundation
@testable import InMemoryTaskRepository

@MainActor
@Suite("Task List ViewModel Unit Tests")
struct TaskListViewModelTests {
  @Test func addNewButtonTapped() {
    let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    let now = Date(timeIntervalSince1970: 0)
    let sut = TaskListViewModel(
      taskRepository: .inMemory,
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
          creationDate: now,
          category: nil
        )
      )
    )
  }
  
  @Test func taskTapped() async {
    let task = TaskState.mock
    let sut = TaskListViewModel(taskRepository: InMemoryTaskRepository(tasks: [task]))
    
    await sut.onAppear() // Load data
    
    sut.taskTapped(task)
    
    #expect(sut.destination == .edit(task))
  }
  
  @Test func deleteTask() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.onAppear() // Load data
    
    await sut.deleteTask(at: [1])
    
    #expect(sut.filteredTasks.count == 2)
    #expect(sut.filteredTasks == [.mock, .mock3])
  }
  
  @Test func deleteTasksRange() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.onAppear() // Load data

    await sut.deleteTask(at: [0, 2])
    
    #expect(sut.filteredTasks.count == 1)
    #expect(sut.filteredTasks == [.mock2])
  }
  
  @Test func saveNewTaskButtonTapped() async {
    let task = TaskState.mock
    let sut = TaskListViewModel(taskRepository: InMemoryTaskRepository(tasks: []))
    
    await sut.saveNewTaskButtonTapped(task)
    
    #expect(sut.filteredTasks.count == 1)
    #expect(sut.filteredTasks.first == task)
    #expect(sut.destination == nil)
  }
  
  @Test func cancelAddingNewTaskButtonTapped() {
    let sut = TaskListViewModel(
      destination: .add(TaskState.mock),
      taskRepository: .inMemory
    )
    
    sut.cancelAddingNewTaskButtonTapped()
    
    #expect(sut.destination == nil)
  }
  
  @Test func updateTaskButtonTapped() async {
    let task = TaskState.mock
    let updatedTask = TaskState(
        id: task.id,
        name: "Updated Task",
        priorityLevel: .high,
        status: .inProgress,
        dueDate: Date(timeIntervalSince1970: 1_000_555_555),
        creationDate: Date(timeIntervalSince1970: 850_000_000),
        category: nil
    )
    
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock2, task, .mock3])
    )
    
    await sut.onAppear() // Load data
    
    await sut.updateTaskButtonTapped(updatedTask)
    
    #expect(sut.filteredTasks.count == 3)
    #expect(sut.filteredTasks == [.mock2, updatedTask, .mock3])
    #expect(sut.destination == nil)
  }
  
  @Test func cancelEditingTaskButtonTapped() {
    let sut = TaskListViewModel(destination: .edit(TaskState.mock), taskRepository: .inMemory)
    
    sut.cancelEditingTaskButtonTapped()
    
    #expect(sut.destination == nil)
  }

  // MARK: - Sorting Tests
  
  @Test func changeSortOrderToDueDateAscending() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.changeSortOrder(to: .dueDateAscending)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changeSortOrderToDueDateDescending() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.changeSortOrder(to: .dueDateDescending)
    
    #expect(sut.filteredTasks == [.mock3, .mock2, .mock])
  }
  
  @Test func changeSortOrderToPriorityAscending() async {
    let task1 = TaskState.mock // Low
    let task2 = TaskState.mockHighPriority
    let task3 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [task1, task2, task3])
    )
    
    await sut.changeSortOrder(to: .priorityAscending)
    
    #expect(sut.filteredTasks == [task1, task3, task2])
  }
  
  @Test func changeSortOrderToPriorityDescending() async {
    let task1 = TaskState.mock // Low
    let task2 = TaskState.mockHighPriority
    let task3 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [task1, task2, task3])
    )
    
    await sut.changeSortOrder(to: .priorityDescending)
    
    #expect(sut.filteredTasks == [task2, task3, task1])
  }
  
  @Test func changeSortOrderToCreationDateAscending() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.changeSortOrder(to: .creationDateAscending)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changeSortOrderToCreationDateDescending() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )

    await sut.changeSortOrder(to: .creationDateDescending)
    
    #expect(sut.filteredTasks == [.mock3, .mock2, .mock])
  }
  
  // MARK: - Filtering Tests
  
  @Test func changePriorityLevelFilter() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )

    await sut.changePriorityLevelFilter(to: .low)
    
    #expect(sut.filteredTasks == [.mock, .mock2, .mock3])
  }
  
  @Test func changePriorityLevelFilterToHigh() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )

    await sut.changePriorityLevelFilter(to: .high)
    
    #expect(sut.filteredTasks.isEmpty)
  }
  
  @Test func changePriorityLevelFilterToMedium() async {
    let task1 = TaskState.mock
    let task2 = TaskState.mockMediumPriority
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [task1, task2, .mock3])
    )

    await sut.changePriorityLevelFilter(to: .medium)
    
    #expect(sut.filteredTasks == [task2])
  }
  
  @Test func clearPriorityLevelFilter() async {
    let sut = TaskListViewModel(
      taskRepository: InMemoryTaskRepository(tasks: [.mock, .mock2, .mock3])
    )
    
    await sut.changePriorityLevelFilter(to: .low)
    
    await sut.changePriorityLevelFilter(to: nil)
    
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
    creationDate: Date(timeIntervalSince1970: 700_000_000),
    category: nil
  )
  
  @MainActor static let mock2 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
    name: "TODO: Fix UI",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_100_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000),
    category: nil
  )
  
  @MainActor static let mock3 = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
    name: "FIXME: Implement modular navigation",
    priorityLevel: .low,
    status: .inProgress,
    dueDate: Date(timeIntervalSince1970: 1_200_000_000),
    creationDate: Date(timeIntervalSince1970: 900_000_000),
    category: nil
  )

  @MainActor static let mockHighPriority = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
    name: "High Priority Task",
    priorityLevel: .high,
    status: .pending,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 800_000_000),
    category: nil
  )

  @MainActor static let mockMediumPriority = TaskState(
    id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
    name: "Medium Priority Task",
    priorityLevel: .medium,
    status: .pending,
    dueDate: Date(timeIntervalSince1970: 1_000_000_000),
    creationDate: Date(timeIntervalSince1970: 900_000_000),
    category: nil
  )
}
