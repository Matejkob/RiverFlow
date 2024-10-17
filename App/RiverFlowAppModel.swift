import Combine
import UserPreferencesRepository
import NotificationCenter

@MainActor final class RiverFlowAppModel: ObservableObject {
  private let requestNotificationAuthorization: () async throws -> Bool
  private var userPreferencesRepository: UserPreferencesRepository
  
  init(
    requestNotificationAuthorization: @escaping () async throws -> Bool = {
      let center = UNUserNotificationCenter.current()
      return try await center.requestAuthorization(options: [.alert, .sound, .badge])
    },
    userPreferencesRepository: UserPreferencesRepository
  ) {
    self.requestNotificationAuthorization = requestNotificationAuthorization
    self.userPreferencesRepository = userPreferencesRepository
  }
   
  func requestNotificationPermission() async {
    do {
      let isAuthorized = try await requestNotificationAuthorization()
      userPreferencesRepository.notificationsEnabled = isAuthorized
    } catch {
      print("Error requesting notification permission: \(error.localizedDescription)")
      userPreferencesRepository.notificationsEnabled = false
    }
  }
}
