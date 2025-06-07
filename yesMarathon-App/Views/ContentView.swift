//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    // -----データベースから情報を取得-----
    @Environment(\.modelContext) private var modelContext
    @Query private var dayChangeManager: [DayChangeManager]
    // ------------------------------

    @State private var currentManager: DayChangeManager?
    @State private var yesLabel: String = YesSuggestion().random()
    let yesSuggestion = YesSuggestion()

    var body: some View {
        Group {
            if currentManager?.isTrue == true { // isTrue == true
                AchievedView()
            } else if currentManager?.isTrue == false { // isTrue == true
                HomeView(yesLabel: $yesLabel)
            } else {
                Text("画面読み込みに失敗しました")
            }
        }
        .onAppear {
            if dayChangeManager.isEmpty {
                currentManager = initializeManager()
            } else {
                currentManager = dayChangeManager.first
            }
            startYesLabelUpdate()
        }
        .onChange(of: dayChangeManager) { _ in
            currentManager = dayChangeManager.first
        }
    }

    private func initializeManager() -> DayChangeManager {
        let newManager = DayChangeManager()
        modelContext.insert(newManager)
        try? modelContext.save()
        return newManager
    }

    private func startYesLabelUpdate() {
        guard let midnight = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else {
            print("Failed to calculate the next midnight.")
            return
        }

        let timeInterval = midnight.timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            guard let manager = currentManager else { return }
            manager.isTrue = false
//            manager.yesTitle = yesSuggestion.random()
            do {
                try modelContext.save()
                DispatchQueue.main.async {
                    currentManager = manager
//                    yesLabel = manager.yesTitle
                }
            } catch {
                print("Failed to save updates to currentManager: \(error.localizedDescription)")
            }
            startYesLabelUpdate()
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
