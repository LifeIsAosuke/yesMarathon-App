//
//  NotificationManager.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/07.
//

import Foundation
import UserNotifications

final class NotificationManager {
    // インスタンスを生成
    static let instance: NotificationManager = NotificationManager()
    
    // 権限リクエスト
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                if let error = error {
                    print("通知の権限リクエスト中にエラーが発生しました: \(error.localizedDescription)")
                } else {
                    print("通知が許可されました: \(granted)")
                }
            }
    }
    
    // 通知の登録(朝)
    func sendNotification_morning() {
        
        let content = UNMutableNotificationContent()
        content.title = "YESマラソン"
        content.body = "今日もYESな1日を！！🔥"
        
        // 通知する時刻を指定
        var date = DateComponents()
        date.hour = 8
        date.minute = 0
        
        // 毎日この時間になると通知
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for debug
        
        
        let request = UNNotificationRequest(identifier: "notification01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // 通知の登録（夕方）
    func sendNotification_evening() {
        
        let content = UNMutableNotificationContent()
        content.title = "YESマラソン"
        content.body = "今日のYESは達成できた？💪"
        
        // 通知する時刻を指定
        var date = DateComponents()
        date.hour = 17
        date.minute = 0
        
        // 毎日この時間になると通知
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for debug
        
        
        let request = UNNotificationRequest(identifier: "notification01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
