import Domain
import Foundation
import CasePaths
import TaskFeature
import TaskRepository
import UserPreferencesRepository
import Combine

@MainActor public final class TaskListViewModel: ObservableObject, Sendable {
  @CasePathable
  public enum Destination: Equatable {
    case add(TaskState)
    case edit(TaskState)
  }
  
  @Published var destination: Destination?
  @Published var filteredTasks: [TaskState] = []
  @Published var selectedPriorityLevelFilter: TaskPiorityLevel?
  @Published var selectedSortOrder: TaskSortOrder = .creationDateAscending
  
  private let taskRepository: TaskRepository
  private var userPreferencesRepository: UserPreferencesRepository
  private let uuid: () -> UUID
  private let now: () -> Date
  
  private var cancellables: Set<AnyCancellable> = []

  public init(
    destination: Destination? = nil,
    taskRepository: TaskRepository,
    userPreferencesRepository: UserPreferencesRepository,
    uuid: @escaping () -> UUID = UUID.init,
    now: @escaping () -> Date = { Date.now }
  ) {
    self.destination = destination
    self.taskRepository = taskRepository
    self.userPreferencesRepository = userPreferencesRepository
    self.uuid = uuid
    self.now = now
    
    bindUserPreferences()
  }
  
  private func bindUserPreferences() {
    selectedPriorityLevelFilter = userPreferencesRepository.selectedPriorityLevelFilter
    selectedSortOrder = userPreferencesRepository.selectedSortOrder
    
    $selectedSortOrder
      .removeDuplicates()
      .sink { [weak self] newValue in
        self?.userPreferencesRepository.selectedSortOrder = newValue
      }
      .store(in: &cancellables)
    
    $selectedPriorityLevelFilter
      .removeDuplicates()
      .sink { [weak self] newValue in
        self?.userPreferencesRepository.selectedPriorityLevelFilter = newValue
      }
      .store(in: &cancellables)
  }
  
  func onAppear() async {
    await updateTasksList()
  }
  
  func addNewButtonTapped() {
    destination = .add(
      TaskState(
        id: uuid(),
        name: "",
        priorityLevel: .low,
        status: .pending,
        dueDate: now() + 60 * 60 * 24,
        creationDate: now(),
        category: nil
      )
    )
  }
  
  func taskTapped(_ task: TaskState) {
    destination = .edit(task)
  }
  
  func deleteTask(at offsets: IndexSet) async {
    let taskToDelete = offsets.map { filteredTasks[$0] }
    
    filteredTasks.remove(atOffsets: offsets)
    
    for task in taskToDelete {
      try? await taskRepository.deleteTask(task)
    }
    
    // We don't need to fetch tasks here again
    // since UI has been already updated
  }
  
  func saveNewTaskButtonTapped(_ task: TaskState) async {
    try? await taskRepository.saveTask(task)
    
    await updateTasksList()
    
    destination = nil
  }
  
  func cancelAddingNewTaskButtonTapped() {
    destination = nil
  }
  
  func updateTaskButtonTapped(_ task: TaskState) async {
    try? await taskRepository.updateTask(task)
    
    await updateTasksList()
    
    destination = nil
  }
  
  func cancelEditingTaskButtonTapped() {
    destination = nil
  }
  
  // MARK: - Sorting and Filtering
  
  func changeSortOrder(to newOrder: TaskSortOrder) async {
    selectedSortOrder = newOrder
    
    await updateTasksList()
  }

  func changePriorityLevelFilter(to piorityLevel: TaskPiorityLevel?) async {
    selectedPriorityLevelFilter = piorityLevel
    
    await updateTasksList()
  }
  
  private func updateTasksList() async {
    let currentSortOrder = selectedSortOrder
    let currentPriorityLevelFilter = selectedPriorityLevelFilter
    
    let savedTask = try? await taskRepository.fetchAllTasks(
      sortBy: currentSortOrder,
      filterBy: currentPriorityLevelFilter
    )
    
    filteredTasks = savedTask ?? []
  }
}
