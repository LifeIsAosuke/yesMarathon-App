//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    
    // データベースの情報管理用
    @Environment(\.modelContext) private var modelContext
    @Query private var dayChangeManager: [DayChangeManager] // データベースから管理データを取得

    @State private var yesLabel: String = YesSuggestion().random()
    let yesSuggestion = YesSuggestion()

    var body: some View {
        Group {
            if currentManager.isTrue {
                AchievedView()
            } else {
                HomeView(yesLabel: $yesLabel)
            }
        }
        .onAppear {
            if dayChangeManager.isEmpty {
                initializeManager()
            }
            startYesLabelUpdate()
        }
    }

    private var currentManager: DayChangeManager {
        dayChangeManager.first ?? initializeManager()
    }

    private func initializeManager() -> DayChangeManager {
        let newManager = DayChangeManager()
        modelContext.insert(newManager)
        try? modelContext.save()
        return newManager
    }

    private func startYesLabelUpdate() {
        let midnight = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        let timeInterval = midnight.timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            currentManager.isTrue = false
            try? modelContext.save()
            yesLabel = yesSuggestion.random()
            startYesLabelUpdate() // Restart the timer for the next day
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [DayChangeManager.self, EachDayData.self])
}



#Preview {
    ContentView()
}
