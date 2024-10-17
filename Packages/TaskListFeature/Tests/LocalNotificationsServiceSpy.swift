import Domain
import LocalNotificationsService

class LocalNotificationsServiceSpy: LocalNotificationsService {
  var scheduleNotificationCallsCount = 0
  var receivedScheduleArguments: [TaskState] = []
  
  func scheduleNotification(for task: TaskState) {
    scheduleNotificationCallsCount += 1
    receivedScheduleArguments.append(task)
  }
  
  var updateNotificationCallsCount = 0
  var receivedUpdateArguments: [TaskState] = []
  
  func updateNotification(for task: TaskState) {
    updateNotificationCallsCount += 1
    receivedUpdateArguments.append(task)
  }
  
  var cancelNotificationCallsCount = 0
  var receivedCancelArguments: [TaskState] = []
  
  func cancelNotification(for task: TaskState) {
    cancelNotificationCallsCount += 1
    receivedCancelArguments.append(task)
  }
}

extension LocalNotificationsService where Self == LocalNotificationsServiceSpy {
  static var spy: Self { LocalNotificationsServiceSpy() }
}
