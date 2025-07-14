//
//  SettingView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import SwiftUI
import SwiftData
import PhotosUI
import StoreKit

struct SettingView: View {
    
    @EnvironmentObject var userInfoManager: UserInfoManager
    
    // 画像に関する変数
    
    @State private var isNotificationOn: Bool = false
    
    
    // 画面キルに関する変数
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    Divider()
                    Toggle("通知設定", isOn: $userInfoManager.isNotificationOn)
                        .onChange(of: userInfoManager.isNotificationOn) { isOn in
                            if isOn {
                                NotificationManager.instance.requestPermission()
                                NotificationManager.instance.sendNotification_morning()
                                NotificationManager.instance.sendNotification_evening()
                                print("通知が有効化されました")
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                print("通知が無効化されました")
                            }
                        }
                        .tint(Color.yesOrange)
                        .padding()
                    Divider()
                    
                    Button {
                        openURL("https://docs.google.com/forms/d/e/1FAIpQLSeis1VJf5Ygvl-NnK629AIbMeHRsazFZ-tM5tLL8-hThlIo2g/viewform?usp=dialog")
                    } label: {
                        HStack {
                            Text("ご意見・お問い合わせ")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.black)
                        .padding()
                    }
                    
                    Divider()
                    Button {
                        requestReview()
                    } label: {
                        HStack {
                            Text("このアプリを評価する")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    Divider()
                    
                    ShareLink(item: URL(string: "https://apps.apple.com/jp/app/yesmarathon/id6746979101")!) {
                        HStack {
                            Text("共有する")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.black)
                        .padding()
                    }
                              
                    Divider()
                    
                    HStack {
                        Text("カテゴリーを選択:")
                        
                        Spacer()
                        
                        Picker("カテゴリーを選択:", selection: userInfoManager.$yesCategory) {
                            Text("恋愛💞").tag(0)
                            Text("対人関係👥").tag(1)
                            Text("趣味開拓⚽️").tag(2)
                            Text("行動🏃").tag(3)
                            Text("学び📚").tag(4)
                            Text("冒険⚔️").tag(5)
                            Text("ランダム").tag(6)
                        }
                        .tint(Color.yesOrange)
                    }
                    .padding()
                    
                    Divider()
                    
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        
                        Text("完了")
                        
                        
                    }
                    .foregroundColor(.black)
                    .bold()
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//#Preview {
//    SettingView()
//        .modelContainer(for: [UserInfoManager.self])
//}
