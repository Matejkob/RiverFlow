import SwiftUI
import TaskListFeature
import GRDBTaskRepository

@main
struct RiverFlowApp: App {
  var body: some Scene {
    WindowGroup {
      TaskListView(
        viewModel: TaskListViewModel(
          taskRepository: .GRDB
        )
      )
    }
  }
}
