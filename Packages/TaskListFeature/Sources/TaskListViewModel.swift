import Domain
import Foundation
import CasePaths
import TaskFeature

@MainActor public final class TaskListViewModel: ObservableObject {
  @CasePathable
  public enum Destination: Equatable {
    case add(TaskState)
    case edit(TaskState)
  }

  private var tasks: [TaskState]
  
  @Published var destination: Destination?
  @Published var filteredTasks: [TaskState] = []
  @Published var selectedPriorityLevelFilter: TaskPiorityLevel?
  @Published var selectedSortOrder: TaskSortOrder = .creationDateAscending
  
  private let uuid: () -> UUID
  private let now: () -> Date

  public init(
    tasks: [TaskState] = [],
    destination: Destination? = nil,
    uuid: @escaping () -> UUID = UUID.init,
    now: @escaping () -> Date = { Date.now }
  ) {
    self.tasks = tasks
    self.destination = destination
    self.uuid = uuid
    self.now = now
    
    applyFilters()
  }
  
  func addNewButtonTapped() {
    destination = .add(
      TaskState(
        id: uuid(),
        name: "",
        priorityLevel: .low,
        status: .pending,
        dueDate: now() + 60 * 60 * 24,
        creationDate: now()
      )
    )
  }
  
  func taskTapped(_ task: TaskState) {
    destination = .edit(task)
  }
  
  func deleteTask(at offsets: IndexSet) {
    let taskToDelete = offsets.map { filteredTasks[$0] }
    
    filteredTasks.remove(atOffsets: offsets)
    
    for task in taskToDelete {
      tasks.removeAll(where: { $0.id == task.id })
    }
  }
  
  func saveNewTaskButtonTapped(_ task: TaskState) {
    tasks.append(task)
    
    applyFilters() // Re-apply filter after adding new task
    
    destination = nil
  }
  
  func cancelAddingNewTaskButtonTapped() {
    destination = nil
  }
  
  func updateTaskButtonTapped(_ task: TaskState) {
    defer { destination = nil }
    
    guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }
   
    tasks[index] = task
   
    applyFilters() // Re-apply filter after updating task
  }
  
  func cancelEditingTaskButtonTapped() {
    destination = nil
  }
  
  // MARK: - Sorting and Filtering
  
  func changeSortOrder(to newOrder: TaskSortOrder) {
    selectedSortOrder = newOrder
    
    Self.sort(tasks: &filteredTasks, by: newOrder)
  }

  func changePriorityLevelFilter(to piorityLevel: TaskPiorityLevel?) {
    selectedPriorityLevelFilter = piorityLevel
    
    applyFilters()
  }
  
  private func applyFilters() {
    var tasksToFilter = tasks
    
    if let selectedPriorityLevelFilter {
      tasksToFilter = tasksToFilter.filter { $0.priorityLevel == selectedPriorityLevelFilter }
    }
    
    Self.sort(tasks: &tasksToFilter, by: selectedSortOrder)
    
    filteredTasks = tasksToFilter
  }
  
  private static func sort(tasks: inout [TaskState], by sortOrder: TaskSortOrder) {
    switch sortOrder {
    case .creationDateAscending:
      tasks.sort { $0.creationDate < $1.creationDate }
      
    case .creationDateDescending:
      tasks.sort { $0.creationDate > $1.creationDate }
      
    case .dueDateAscending:
      tasks.sort { $0.dueDate < $1.dueDate }
      
    case .dueDateDescending:
      tasks.sort { $0.dueDate > $1.dueDate }
      
    case .priorityAscending:
      tasks.sort { $0.priorityLevel.rawValue < $1.priorityLevel.rawValue }
      
    case .priorityDescending:
      tasks.sort { $0.priorityLevel.rawValue > $1.priorityLevel.rawValue }
    }
  }
}
