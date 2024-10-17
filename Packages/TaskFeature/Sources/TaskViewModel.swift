import Combine
import Domain
import Foundation
import CasePaths

@MainActor public final class TaskViewModel: ObservableObject {
  @CasePathable
  public enum Destination: Equatable {
    case validationAlert(message: String)
  }
  
  @Published var task: TaskState
  @Published var destination: Destination?
  
  private let onSave: (TaskState) -> Void
  private let onCancel: () -> Void
  private let taskNameValidator: TaskNameValidatorProtocol
  private let taskDueDateValidator: TaskDueDateValidatorProtocol
  
  public init(
    task: TaskState,
    destination: Destination? = nil,
    onSave: @escaping (TaskState) -> Void,
    onCancel: @escaping () -> Void,
    taskNameValidator: TaskNameValidatorProtocol = TaskNameValidator(),
    taskDueDateValidator: TaskDueDateValidatorProtocol = TaskDueDateValidator()
  ) {
    self.task = task
    self.destination = destination
    self.onSave = onSave
    self.onCancel = onCancel
    self.taskNameValidator = taskNameValidator
    self.taskDueDateValidator = taskDueDateValidator
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
  
  func saveButtonTapped() {
    if case let .failure(message) = taskNameValidator.validate(task.name) {
      destination = .validationAlert(message: message)
      return
    }
    
    if case let .failure(message) = taskDueDateValidator.validate(task.dueDate) {
      destination = .validationAlert(message: message)
      return
    }
    
    onSave(task)
  }
  
  func cancelButtonTapped() {
    onCancel()
  }
  
  func cancelValidationAlertButtonTapped() {
    destination = nil
  }
}
