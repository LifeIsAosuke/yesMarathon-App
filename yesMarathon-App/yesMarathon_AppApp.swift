//
//  yesMarathon_AppApp.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI
import SwiftData

@main
struct yesMarathon_AppApp: App {
    
    // 通知設定
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [EachDayData.self])
        }
    }
}
