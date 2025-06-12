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
    //DayChangeManager型のインスタンスを全て取得
    @Query private var dayChangeManager: [DayChangeManager]
    @State private var currentDayChangeManager: DayChangeManager?
    
    //UserInfoManager型のインスタンスを全て取得
    @Query private var userInfoManager: [UserInfoManager]
    @State private var currentUserInfo: UserInfoManager?
    // ------------------------------

    var body: some View {
        
        Group {
            if currentDayChangeManager?.isTrue == true { // isTrue == true
                AchievedView()
            } else if currentDayChangeManager?.isTrue == false { // isTrue == true
                HomeView()
            } else {
                Text("画面読み込みに失敗しました")
            }
        }
        .onAppear {
            if isInitialized() { // 初回起動時
                initializeManager()
            }
            
            // 初回起動後や2回目以降のログイン時に必ずデータを設定
            currentDayChangeManager = dayChangeManager.first ?? {
                let manager = DayChangeManager(yesTitle: YesSuggestion().random())
                modelContext.insert(manager)
                return manager
            }()
            
            currentUserInfo = userInfoManager.first ?? {
                let manager = UserInfoManager()
                modelContext.insert(manager)
                return manager
            }()
            
            do {
                try modelContext.save()
            } catch {
                print("初期データの保存に失敗しました: \(error.localizedDescription)")
            }
            
            // 本日のYESを更新
            startYesLabelUpdate()
        }
//        .onChange(of: dayChangeManager) { _ in
//            currentManager = dayChangeManager.first
//        }
    }
    
    //　アプリの初回起動かどうかを確かめる関数
    private func isInitialized() -> Bool {
        // 両方のデータが存在する場合に「初期化済み」とみなす
        return !dayChangeManager.isEmpty && !userInfoManager.isEmpty
    }

    // 各Managerの初期化
    private func initializeManager() {
        let newDayChangeManager = DayChangeManager(yesTitle: YesSuggestion().random())
        let newUserInfoManager = UserInfoManager()

        modelContext.insert(newDayChangeManager)
        modelContext.insert(newUserInfoManager)
        
        do {
            try modelContext.save() // データベースに変更内容を保存
            currentDayChangeManager = newDayChangeManager
            currentUserInfo = newUserInfoManager
        } catch {
            print("初期化に失敗しました: \(error.localizedDescription)")
        }
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
            guard let manager = currentDayChangeManager else { return }
            
            currentDayChangeManager?.isTrue = false // 本日のYES達成をfalseに
            currentDayChangeManager?.EditYesTitle(yesTitle: YesSuggestion().random())
            
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
        .modelContainer(for: [DayChangeManager.self, EachDayData.self, UserInfoManager.self])
}



#Preview {
    ContentView()
}

