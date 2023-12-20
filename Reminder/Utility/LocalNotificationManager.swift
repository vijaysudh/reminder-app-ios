//  LocalNotificationManager.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import UIKit

enum NotificationAuthorization {
    case authorized
    case requestAuthorization
    case denied
}

enum LocalNotificationError: Error {
    case denined
    case invalidDate(date: Date)
    case creation
}

extension LocalNotificationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .denined:
            return "Reminder app notification settings is disabled"
        case .invalidDate(let date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale.current
            let localDate = dateFormatter.string(from: date)
            return "Cannot set reminder notification at: \(localDate)"
        case .creation:
            return "Unable to create notification"
        }
    }
}

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationName = Notification.Name("ReminderAlarm")
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestPermissionFromUser() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Authorized local notification")
            } else {
                print("Authorization error: ", error?.localizedDescription ?? "Not granted")
            }
        }
    }
    
    func checkAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        authorizationStatus { result in
            switch result {
            case .success(let status):
                if status == .requestAuthorization {
                    self.requestPermissionFromUser()
                }
                completion(.success(true))
            case .failure(let error):
                print("CheckAuthorization Auth Error: ", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
        
    func scheduleNotification(title: String, body: String?, remindAt: Date, userInfo: [String: String], completion: @escaping (Result<UUID, Error>) -> Void) {
        authorizationStatus { result in
            switch result {
            case .success(let status):
                if status == .authorized {
                    self.sendNotification(title: title, body: body, remindAt: remindAt, userInfo: userInfo) { notificationResult in
                        switch notificationResult {
                            case .success(let notificationId): 
                                completion(.success(notificationId))
                            case .failure(let error): 
                                completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                print("LocalNotificationManager Auth Error: ", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func clearDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    /** Handle notification when the app is in background */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:
    UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        // handle the notification here
        NotificationCenter.default.post(name:notificationName , object: content)
    }
    
    /** Handle notification when the app is in foreground */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
             willPresent notification: UNNotification,
             withCompletionHandler completionHandler:
                @escaping (UNNotificationPresentationOptions) -> Void) {
       
        let content = notification.request.content
        // handle the notification here
        NotificationCenter.default.post(name:notificationName , object: content)
    }
}

private extension LocalNotificationManager {
    private func authorizationStatus(completion: @escaping (Result<NotificationAuthorization, Error>) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                // ask user for permission
                completion(.success(.requestAuthorization))
            case .authorized:
                // Authorized
                completion(.success(.authorized))
            case .provisional:
                // Authorized
                completion(.success(.authorized))
            case .ephemeral:
                // Not required to be handled
                completion(.success(.authorized))
            case .denied:
                // Disaplay an alert to the user to change their settings
                completion(.failure(LocalNotificationError.denined))
            @unknown default:
                // Treat it the same as denined
                completion(.failure(LocalNotificationError.denined))
            }
        }
    }
    
    private func sendNotification(title: String, body: String?, remindAt: Date, userInfo: [String: String], completion: @escaping (Result<UUID, Error>) -> Void) {
        let timeInterval = remindAt - Date()
        guard timeInterval > 0 else {
            completion(.failure(LocalNotificationError.invalidDate(date: remindAt)))
            return
        }
        
        // TODO: Remove temp code once Local Peristance storage has been added
        notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "Reminder"
        content.sound = UNNotificationSound.default
        content.title = title
        content.userInfo = userInfo
        
        if let body = body {
            content.body = body
        }
        // Set the notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        // Create a unique identifier for the notification
        let identifier = UUID()
        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier.uuidString, content: content, trigger: trigger)
        // Schedule the notification
        notificationCenter.add(request) { (error) in
            if let error = error {
                completion(.failure(LocalNotificationError.creation))
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                completion(.success(identifier))
                print("Notification scheduled successfully!")
            }
        }
    }
}


