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
    @Query private var dayChangeManager: [DayChangeManager] // データベースに登録されているDayChangeManager型のインスタンスを全て取得
    
    
    // ------------------------------
    @State private var currentManager: DayChangeManager?

    var body: some View {
        
        Group {
            if currentManager?.isTrue == true { // isTrue == true
                AchievedView()
            } else if currentManager?.isTrue == false { // isTrue == true
                HomeView()
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
        
        
        modelContext.insert(newManager)
        try? modelContext.save() // データベースに変更内容を保存
        
        return newManager
    }

    private func startYesLabelUpdate() {
        // 次の午前０時を計算
        guard let midnight = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else {
            print("時刻の計算に失敗しました")
            return
        }

        // 次の午前０時までの時間を計算（タイマーの時間間隔として利用）
        let timeInterval = midnight.timeIntervalSinceNow

        
        // 日付が変わったら呼び出されるタイマー
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            
            // currentManagerがインスタンス化されているか確認
            guard let manager = currentManager else { return }
            
            currentManager?.isTrue = false // 本日のYES達成をfalseに
            currentManager?.EditYesTitle(yesTitle: YesSuggestion().random())
            
            do {
                try modelContext.save()
            } catch {
                print("managerの更新に失敗しました: \(error.localizedDescription)")
            }
            
            // 通知設定
            NotificationManager.instance.sendNotification_morning()
            NotificationManager.instance.sendNotification_evening()
            
            // 再びこの関数を実行
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

