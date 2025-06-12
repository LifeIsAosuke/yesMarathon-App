//
//  SettingView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    // データベースから情報を取得
    @Environment(\.modelContext) private var modelContext
    @Query private var userInfoManager: [UserInfoManager]
    
    
    // 画面キルに関する変数
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    Spacer()
                    
                    Image(systemName: "person.crop.circle")
                        .scaleEffect(6)
                    
                    Spacer()
                    
                    Text("userName")
                        .bold()
                    
                    Spacer()
                    
                    Divider()
                    Toggle("通知設定", isOn: .constant(true))
                        .padding()
                    
                    Divider()
                    Text("本日のYESジャンル設定")
                    Divider()
                    HStack {
                        Text("アプリの評価")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    Divider()
                    HStack {
                        Text("ご意見")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    Divider()
                    HStack {
                        Text("このアプリを共有する")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    Divider()
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("完了")
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
        
        
        
    }
}

#Preview {
    SettingView()
}
