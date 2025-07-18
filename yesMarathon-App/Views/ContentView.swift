//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//
import SwiftUI
import SwiftData
import OpenAI
import WidgetKit

struct ContentView: View {
    
    @StateObject var dayChangeManager = DayChangeManager()
    @StateObject var userInfoManager = UserInfoManager()
    
    @StateObject var chatGPT = ChatGPT()

    var body: some View {
        
        Group {
            if dayChangeManager.isTrue == true { // isTrue == true
                AchievedView()
            } else if dayChangeManager.isTrue == false { // isTrue == true
                HomeView()
            } else {
                Text("画面読み込みに失敗しました")
                Text("Managerの初期化に失敗しています")
            }
        }
        .environmentObject(dayChangeManager)
        .environmentObject(userInfoManager)
        .environmentObject(chatGPT)
        .onAppear {
            // 日付変更確認と処理
            checkAndUpdateDateChange()
        }
    }
    
    // 日付が変わったかを検証する関数
    private func checkAndUpdateDateChange() {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastLogin = dayChangeManager.lastLoginDate ?? Date.distantPast

        // 最後にログインした日付と現在の日付が異なる場合
        if calendar.isDate(today, inSameDayAs: lastLogin) == false {
            dayChangeManager.isTrue = false // 本日のYES達成をリセット
            
            Task { // YESタイトルの更新
                await changeYesTitle()
            }
            
            dayChangeManager.lastLoginDate = today // 最終ログイン日を更新
        }
    }
    
    private func changeYesTitle() async {
        await chatGPT.fetchOpenAIResponse(categoryValue: userInfoManager.yesCategory)
        dayChangeManager.yesTitle = chatGPT.getResponseText()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    ContentView()
}

