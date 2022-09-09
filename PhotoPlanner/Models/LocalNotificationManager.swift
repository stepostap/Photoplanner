
import Foundation
import UserNotifications

struct localNotification {
    var id: String
    var title: String
    var body: String
    var datetime: DateComponents
}

class LocalNotificationManager
{
    var notifications = [localNotification]()
    
    func getCurrentNotificationsId(closure: @escaping (String) -> ()) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                closure(notification.identifier)
            }
        }
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break 
            }
        }
    }
    
    func deleteNotification (id :  [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}
