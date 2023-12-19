//  ReminderNotification.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import UIKit

class ReminderNotification {
    
    @objc func isAuthorized() -> Bool {
        var result: Bool = false
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            result = settings.authorizationStatus == .authorized ? true : false
        }
        return result
    }
    
    @objc func registerLocal() {
        if !isAuthorized() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Authorized local notification")
                } else {
                    print("Authorization error: ", error?.localizedDescription ?? "NA")
                }
            }
        }
    }
    
    func scheduleNotification(title: String, body: String?, remindAt: Date) {
        registerLocal()
        let timeInterval = remindAt - Date()
        guard timeInterval > 0 else {
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
        let identifier = UUID().uuidString
        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // Schedule the notification
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }
}


