//
//  AppDelegate.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/07.
//

// アプリ起動時に通知の権限を求める
import Foundation
import NotificationCenter
import UIKit

import Foundation
import NotificationCenter
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // リクエストのメソッド呼び出し
       NotificationManager.instance.requestPermission()
       
       UNUserNotificationCenter.current().delegate = self

       return true
   }

}
