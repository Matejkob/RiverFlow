import SwiftUI
import TaskListFeature
import GRDBTaskRepository
import DefaultUserPreferencesRepository
import UILocalNotificationsService

@main
struct RiverFlowApp: App {
  @StateObject private var appModel = RiverFlowAppModel(userPreferencesRepository: .userDefaults)
  
  var body: some Scene {
    WindowGroup {
      TaskListView(
        viewModel: TaskListViewModel(
          taskRepository: .GRDB,
          userPreferencesRepository: .userDefaults,
          localNotificationsService: .uiLocalNotifications
        )
      )
      .task { await appModel.requestNotificationPermission() }
    }
  }
}
