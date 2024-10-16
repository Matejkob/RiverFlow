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
              name: "name 1",
              priorityLevel: .high,
              status: .inProgress,
              dueDate: Date() + 20
            ),
            TaskState(
              id: UUID(),
              name: "name 2",
              priorityLevel: .medium,
              status: .inProgress,
              dueDate: Date() + 20
            ),
            TaskState(
              id: UUID(),
              name: "name 3",
              priorityLevel: .low,
              status: .inProgress,
              dueDate: Date() + 20
            )
          ]
        )
      )
    }
  }
}
