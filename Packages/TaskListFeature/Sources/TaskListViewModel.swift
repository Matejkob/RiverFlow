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

  @Published var destination: Destination?
  @Published var tasks: [TaskState] = []
  
  private let uuid: () -> UUID
  private let now: () -> Date

  public init(
    destination: Destination? = nil,
    tasks: [TaskState] = [],
    uuid: @escaping () -> UUID = UUID.init,
    now: @escaping () -> Date = { Date.now }
  ) {
    self.destination = destination
    self.tasks = tasks
    self.uuid = uuid
    self.now = now
  }
  
  func addNewButtonTapped() {
    destination = .add(
      TaskState(
        id: uuid(),
        name: "",
        priorityLevel: .low,
        status: .pending,
        dueDate: now() + 60 * 60 * 24
      )
    )
  }
  
  func taskTapped(_ task: TaskState) {
    destination = .edit(task)
  }
  
  func deleteTask(at offset: IndexSet) {
    tasks.remove(atOffsets: offset)
  }
  
  func saveNewTaskButtonTapped(_ task: TaskState) {
    tasks.insert(task, at: 0)
    destination = nil
  }
  
  func cancelAddingNewTaskButtonTapped() {
    destination = nil
  }
  
  func updateTaskButtonTapped(_ task: TaskState) {
    tasks.removeAll(where: { $0.id == task.id })
    tasks.insert(task, at: 0)
    destination = nil
  }
  
  func cancelEditingTaskButtonTapped() {
    destination = nil
  }
}
