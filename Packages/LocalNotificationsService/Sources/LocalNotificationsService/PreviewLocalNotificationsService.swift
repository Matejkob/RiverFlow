import Domain

public struct PreviewLocalNotificationsService: LocalNotificationsService {
  public func scheduleNotification(for task: TaskState) {}
  public func updateNotification(for task: TaskState) {}
  public func cancelNotification(for task: TaskState) {}
}
 
extension LocalNotificationsService where Self == PreviewLocalNotificationsService {
  public static var preview: Self { PreviewLocalNotificationsService() }
}
