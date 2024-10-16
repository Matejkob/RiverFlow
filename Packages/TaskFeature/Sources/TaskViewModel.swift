import Combine
import Domain
import Foundation

@MainActor public final class TaskViewModel: ObservableObject {
  @Published var task: TaskState
  
  private let onSave: (TaskState) -> Void
  private let onCancel: () -> Void
  
  public init(
    task: TaskState,
    onSave: @escaping (TaskState) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.task = task
    self.onSave = onSave
    self.onCancel = onCancel
  }
  
  func nameChanged(to name: String) {
    // TODO: Add validation..
    task.name = name
  }
  
  func priorityLevelChanged(to priorityLevel: TaskPiorityLevel) {
    task.priorityLevel = priorityLevel
  }
  
  func dueDateChanged(to dueDate: Date) {
    // TODO: Add validation...
    task.dueDate = dueDate
  }
  
  func saveButtonTapped() {
    // TODO: Add validation...
    onSave(task)
  }
  
  func cancelButtonTapped() {
    onCancel()
  }
}
