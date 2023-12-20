//  LocalNotificationManager.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import UIKit

enum ReminderNotificationError: Error {
    case unauthorized
    case invalidDate(date: Date)
    case creation
    
    var description: String {
        switch self {
        case .unauthorized:
            return "Reminder app is unauthorized to create a notification"
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

class LocalNotificationManager {
    func scheduleNotification(title: String, body: String?, remindAt: Date, completion: @escaping (Result<UUID, Error>) -> Void) {
        registerLocal()
        let timeInterval = remindAt - Date()
        guard timeInterval > 0 else {
            completion(.failure(ReminderNotificationError.invalidDate(date: remindAt)))
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        // TODO: Remove temp code once Local Peristance storage has been added
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "Reminder"
        content.sound = UNNotificationSound.default
        content.title = title
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
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
                completion(.failure(ReminderNotificationError.creation))
            } else {
                print("Notification scheduled successfully!")
                completion(.success(identifier))
            }
        }
    }
}

private extension LocalNotificationManager {
    //@objc
    private func isAuthorized(completion: @escaping (Result<Bool, Error>) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                completion(.success(true))
            } else {
                completion(.failure(ReminderNotificationError.unauthorized))
            }
        }
    }
    
    private func requestPermissionFromUser() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Authorized local notification")
            } else {
                print("Authorization error: ", error?.localizedDescription ?? "NA")
            }
        }
    }
    
    //@objc
    private func registerLocal() {
        isAuthorized { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                self.requestPermissionFromUser()
            }
        }
    }
}


