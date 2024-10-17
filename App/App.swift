import SwiftUI
import TaskListFeature
import Domain

@main
struct RiverFlowApp: App {
  var body: some Scene {
    WindowGroup {
      TaskListView(
        viewModel: TaskListViewModel(
          tasks: [
            TaskState(
              id: UUID(),
              name: "Task 3",
              priorityLevel: .high,
              status: .inProgress,
              dueDate: Date() + 60 * 4,
              creationDate: Date() - 60
            ),
            TaskState(
              id: UUID(),
              name: "Task 3.1",
              priorityLevel: .medium,
              status: .inProgress,
              dueDate: Date() + 60 * 7,
              creationDate: Date() - 60
            ),
            TaskState(
              id: UUID(),
              name: "Task 2",
              priorityLevel: .medium,
              status: .inProgress,
              dueDate: Date() + 60 * 2,
              creationDate: Date() - 60 * 2
            ),
            TaskState(
              id: UUID(),
              name: "Task 2.1",
              priorityLevel: .low,
              status: .inProgress,
              dueDate: Date() + 60 * 20,
              creationDate: Date() - 60 * 2
            ),
            TaskState(
              id: UUID(),
              name: "Task 1",
              priorityLevel: .low,
              status: .inProgress,
              dueDate: Date() + 60 * 100,
              creationDate: Date() - 60 * 3
            ),
            TaskState(
              id: UUID(),
              name: "Task 1.1",
              priorityLevel: .high,  
              status: .inProgress,
              dueDate: Date() + 60 * 3,
              creationDate: Date() - 60 * 3
            )
          ]
        )
      )
    }
  }
}
