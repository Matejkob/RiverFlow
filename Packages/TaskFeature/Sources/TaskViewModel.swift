import Combine
import TaskRepository
import Domain
import Foundation
import CasePaths
import UserPreferencesRepository
import DefaultUserPreferencesRepository

@MainActor public final class TaskViewModel: ObservableObject {
  @CasePathable
  public enum Destination: Equatable {
    case validationAlert(message: String)
    case addNewCategory
  }
  
  @Published var task: TaskState
  @Published var reminderTimeEnabled: Bool
  @Published var notificationEnabled: Bool
  @Published var categories: [TaskCategory] = []
  @Published var newCategoryName: String = ""
  @Published var destination: Destination?
  
  private let onSave: (TaskState) async -> Void
  private let onCancel: () -> Void
  private let taskNameValidator: TaskNameValidatorProtocol
  private let taskDueDateValidator: TaskDueDateValidatorProtocol
  private let userPreferencesRepository: UserPreferencesRepository
  private let taskRepository: TaskRepository
  private let now: () -> Date
  private let uuid: () -> UUID
  
  public init(
    task: TaskState,
    destination: Destination? = nil,
    onSave: @escaping (TaskState) async -> Void,
    onCancel: @escaping () -> Void,
    taskNameValidator: TaskNameValidatorProtocol = TaskNameValidator(),
    taskDueDateValidator: TaskDueDateValidatorProtocol = TaskDueDateValidator(),
    userPreferencesRepository: UserPreferencesRepository = .userDefaults,
    taskRepository: TaskRepository,
    now: @escaping () -> Date = Date.init,
    uuid: @escaping () -> UUID = UUID.init
  ) {
    self.task = task
    self.reminderTimeEnabled = task.reminderTime != nil
    self.destination = destination
    self.onSave = onSave
    self.onCancel = onCancel
    self.taskNameValidator = taskNameValidator
    self.taskDueDateValidator = taskDueDateValidator
    self.userPreferencesRepository = userPreferencesRepository
    self.taskRepository = taskRepository
    self.now = now
    self.uuid = uuid
    
    notificationEnabled = userPreferencesRepository.notificationsEnabled
  }

  func onAppear() async {
    let savedCategories = try? await taskRepository.fetchAllCategories()
    
    categories = savedCategories ?? []
  }
  
  func nameChanged(to name: String) {
    task.name = name
  }
  
  func priorityLevelChanged(to priorityLevel: TaskPiorityLevel) {
    task.priorityLevel = priorityLevel
  }
  
  func statusChanged(to newTaskStatus: TaskStatus) {
    task.status = newTaskStatus
  }
  
  func dueDateChanged(to dueDate: Date) {
    task.dueDate = dueDate
  }
  
  func reminderTimeToggled(to newValue: Bool) {
    reminderTimeEnabled = newValue
    
    if newValue {
      task.reminderTime = 1 // Default value
    } else {
      // If turned off we need to nil time as well
      task.reminderTime = nil
    }
  }
  
  func reminderTimeChanged(to newReminderTime: TimeInterval) {
    task.reminderTime = newReminderTime
  }
  
  func categoryChanged(to newCategory: TaskCategory?) {
    task.category = newCategory
  }
  
  func addNewCategoryButtonTapped() {
    destination = .addNewCategory
  }
  
  func addNewCategoryCancelButtonTapped() {
    destination = nil
  }
  
  func addNewCategorySaveButtonTapped() async {
    defer { destination = nil }
    
    if newCategoryName.isEmpty { return }
    
    let newCategory = TaskCategory(id: uuid(), name: newCategoryName)
    try? await taskRepository.saveCategory(newCategory)
    
    newCategoryName = ""
    
    let savedCategory = try? await taskRepository.fetchAllCategories()
    
    categories = savedCategory ?? []
    
    task.category = newCategory
  }
  
  func saveButtonTapped() async {
    if case let .failure(message) = taskNameValidator.validate(task.name) {
      destination = .validationAlert(message: message)
      return
    }
    
    if case let .failure(message) = taskDueDateValidator.validate(task.dueDate) {
      destination = .validationAlert(message: message)
      return
    }
    
    await onSave(task)
  }
  
  func cancelButtonTapped() {
    onCancel()
  }
  
  func cancelValidationAlertButtonTapped() {
    destination = nil
  }
}
