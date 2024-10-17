import Domain

public protocol LocalNotificationsService {
  func scheduleNotification(for task: TaskState)
  func updateNotification(for task: TaskState)
  func cancelNotification(for task: TaskState)
}
