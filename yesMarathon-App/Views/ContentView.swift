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
            
            // 日付変更確認と処理
            checkAndUpdateDateChange()
            
            if currentUserInfo?.isNotificationOn == true {
                // 通知設定
                NotificationManager.instance.sendNotification_morning()
                NotificationManager.instance.sendNotification_evening()
            }
        }
    }
    
    //　アプリが初回起動かを確かめる関数
    private func isInitialized() -> Bool {
        // 両方のデータが存在する場合に「初期化済み」とみなす
        return !dayChangeManager.isEmpty && !userInfoManager.isEmpty
    }

    // 各Managerの初期化
    private func initializeManager() {
        
        guard userInfoManager.isEmpty else { return } // 既存データがある場合は初期化をスキップ
        
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
    
    // 日付が変わったかを検証する関数
    private func checkAndUpdateDateChange() {
        guard let currentUser = currentDayChangeManager else { return }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastLogin = currentUser.lastLoginDate ?? Date.distantPast

        // 最後にログインした日付と現在の日付が異なる場合
        if calendar.isDate(today, inSameDayAs: lastLogin) == false {
            handleDateChange() // 日付変更の処理を実行
            currentUser.lastLoginDate = today // 最終ログイン日を更新

            do {
                try modelContext.save() // データベースに保存
            } catch {
                print("日付変更後のデータ保存に失敗しました: \(error.localizedDescription)")
            }
        }
    }
    
    // 日付変更に伴う処理
    private func handleDateChange() {
        guard let manager = currentDayChangeManager else { return }

        manager.isTrue = false // 本日のYES達成をリセット
        manager.yesTitle = YesSuggestion().random()

        do {
            try modelContext.save()
        } catch {
            print("日付変更処理の保存に失敗しました: \(error.localizedDescription)")
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

