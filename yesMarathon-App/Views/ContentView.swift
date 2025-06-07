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
    // データベースに登録されているDayChangeManager型のインスタンスを全て取得
    @Query private var dayChangeManager: [DayChangeManager]
    // ------------------------------

    @State private var currentManager: DayChangeManager?
    
    @State private var yesLabel: String = "Hello World"
    
//    let yesSuggestion = YesSuggestion()

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
            if dayChangeManager.isEmpty { // アプリ初回起動時
                currentManager = initializeManager()
            } else { // 2回目以降のアプリ起動
                currentManager = dayChangeManager.first
            }
            startYesLabelUpdate()
        }
        .onChange(of: dayChangeManager) { _ in
            currentManager = dayChangeManager.first
        }
    }

    private func initializeManager() -> DayChangeManager {
        // DayChangeManagerのインスタンス化
        let newManager = DayChangeManager(yesTitle: YesSuggestion().random())
        yesLabel = newManager.showYesTitle()
        
        
        modelContext.insert(newManager)
        try? modelContext.save() // データベースに変更内容を保存
        
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

        
        // ここのコードもっと簡潔にしよう。managerをわざわざ介す必要なくない？
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            guard let manager = currentManager else { return }
            
            manager.isTrue = false // 画面をHomeViewに
            
            manager.EditYesTitle(yesTitle: YesSuggestion().random()) // 新しいお題に変更
            yesLabel = manager.showYesTitle()
            

            do {
                try modelContext.save() // データベースに変更内容を保存
                DispatchQueue.main.async {
                    currentManager = manager
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
