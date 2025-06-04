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
    // データベースから管理データを取得
    @Query private var dayChangeManager: [DayChangeManager]
    
    //　DayChangeManagerがインスタンス化されていなければ初期化
    private var currentManager: DayChangeManager {
        dayChangeManager.first ?? initializeManager()
    }

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

    // DaychengeManagerの初期化
    private func initializeManager() -> DayChangeManager {
        let newManager = DayChangeManager()
        // swiftDataに追加・更新
        modelContext.insert(newManager)
        try? modelContext.save()
        return newManager
    }

    // 日付を越したか検知する関数
    private func startYesLabelUpdate() {
        let midnight = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        let timeInterval = midnight.timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            // 本日のYES更新
            currentManager.isTrue = false
            try? modelContext.save()
            yesLabel = yesSuggestion.random()
            startYesLabelUpdate() // 再帰的に処理
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
