import Combine
import Domain
import Foundation
import CasePaths
import UserPreferencesRepository
import DefaultUserPreferencesRepository

@MainActor public final class TaskViewModel: ObservableObject {
  @CasePathable
  public enum Destination: Equatable {
    case validationAlert(message: String)
  }
  
  @Published var task: TaskState
  @Published var reminderTimeEnabled: Bool
  @Published var notificationEnabled: Bool
  @Published var destination: Destination?
  
  private let onSave: (TaskState) async -> Void
  private let onCancel: () -> Void
  private let taskNameValidator: TaskNameValidatorProtocol
  private let taskDueDateValidator: TaskDueDateValidatorProtocol
  private let userPreferencesRepository: UserPreferencesRepository
  
  public init(
    task: TaskState,
    destination: Destination? = nil,
    onSave: @escaping (TaskState) async -> Void,
    onCancel: @escaping () -> Void,
    taskNameValidator: TaskNameValidatorProtocol = TaskNameValidator(),
    taskDueDateValidator: TaskDueDateValidatorProtocol = TaskDueDateValidator(),
    userPreferencesRepository: UserPreferencesRepository = .userDefaults
  ) {
    self.task = task
    self.reminderTimeEnabled = task.reminderTime != nil
    self.destination = destination
    self.onSave = onSave
    self.onCancel = onCancel
    self.taskNameValidator = taskNameValidator
    self.taskDueDateValidator = taskDueDateValidator
    self.userPreferencesRepository = userPreferencesRepository
    notificationEnabled = userPreferencesRepository.notificationsEnabled
  }

  func nameChanged(to name: String) {
    task.name = name
  }
  
  func priorityLevelChanged(to priorityLevel: TaskPiorityLevel) {
    task.priorityLevel = priorityLevel
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
