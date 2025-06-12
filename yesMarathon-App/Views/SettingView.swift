//
//  SettingView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import SwiftUI
import SwiftData
import PhotosUI

struct SettingView: View {
    
    // データベースから情報を取得
    @Environment(\.modelContext) private var modelContext
    @Query private var userInfoManager: [UserInfoManager]
    @State private var currentUserInfoManager: UserInfoManager?
    
    // 画像に関する変数
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    @State private var isNotificationOn: Bool = false
    
    
    // 画面キルに関する変数
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    Spacer()
                    
                    // アイコン画像
                    if let imageData = currentUserInfoManager?.userIconData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            
                    } else {
                        Image(systemName: "person.crop.circle")
                            .scaleEffect(6)
                    }
                    
                    Spacer()
  
                    // アイコン変更ボタン
                    PhotosPicker(selection: $selectedItem) {
                        Text("アイコンを変更する")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            do {
                                if let data = try await newItem?.loadTransferable(type: Data.self) {
                                    currentUserInfoManager?.userIconData = data
                                    try modelContext.save()
                                }
                            } catch {
                                print("画像の保存に失敗しました: \(error.localizedDescription)")
                            }
                        }
                    }


                    Spacer()
                    
                    Divider()
                    Toggle("通知設定", isOn: $isNotificationOn)
                        .padding()
                        .onChange(of: isNotificationOn) { _ in
                            currentUserInfoManager?.isNotificationOn = isNotificationOn
                            do {
                                try modelContext.save()
                            } catch {
                                print("通知設定の変更に失敗しました")
                            }
                        }
                    
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
            .onAppear {
                if let userInfo = userInfoManager.first {
                    currentUserInfoManager = userInfo
                    isNotificationOn = userInfo.isNotificationOn
                } else {
                    let newUserInfoManager = UserInfoManager()
                    modelContext.insert(newUserInfoManager)
                    do {
                        try modelContext.save()
                        currentUserInfoManager = newUserInfoManager
                        isNotificationOn = newUserInfoManager.isNotificationOn
                    } catch {
                        print("UserInfoManager の初期化に失敗しました: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    SettingView()
        .modelContainer(for: [UserInfoManager.self])
}
