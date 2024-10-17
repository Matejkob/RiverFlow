import SwiftUI
import TaskListFeature
import GRDBTaskRepository
import DefaultUserPreferencesRepository

@main
struct RiverFlowApp: App {
  var body: some Scene {
    WindowGroup {
      TaskListView(
        viewModel: TaskListViewModel(
          taskRepository: .GRDB,
          userPreferencesRepository: .userDefaults
        )
      )
    }
  }
}
