import UserNotifications
import LocalNotificationsService
import Domain

public final class UILocalNotificationsService: LocalNotificationsService {
  private let notificationCenter = UNUserNotificationCenter.current()
  
  public func scheduleNotification(for task: TaskState) {
    guard let reminderTime = task.reminderTime else {
      // No reminder time set by the user, so no notification needs to be scheduled
      return
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Task Reminder"
    content.body = "Your task \"\(task.name)\" is due soon!"
    content.sound = .default
    
    let notificationDate = task.dueDate.addingTimeInterval(-reminderTime * 60)
    let triggerDate = Calendar.current.dateComponents(
      [.year, .month, .day, .hour, .minute],
      from: notificationDate
    )
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(
      identifier: task.id.uuidString,
      content: content,
      trigger: trigger
    )
    
    notificationCenter.add(request) { error in
      if let error = error {
        print("Error scheduling notification: \(error.localizedDescription)")
      }
    }
  }
  
  public func updateNotification(for task: TaskState) {
    cancelNotification(for: task)
    scheduleNotification(for: task)
  }
  
  public func cancelNotification(for task: TaskState) {
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
  }
}

extension LocalNotificationsService where Self == UILocalNotificationsService {
  public static var uiLocalNotifications: Self { UILocalNotificationsService() }
}
