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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: EachDayData.self)
        }
    }
}
