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
    
    // データベースから情報を取得
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var userInfoManager: UserInfoManager
    
    // 画像に関する変数
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    
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
                    
                    Spacer()
                    
                    // アイコン画像
                    if let imageData = userInfoManager.userIconData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            
                    } else {
                        Image(systemName: "person.crop.circle")
                            .foregroundStyle(Color.yesOrange)
                            .frame(width: 150, height: 150)
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
                                    userInfoManager.userIconData = data
                                
                                }
                            } catch {
                                print("画像の保存に失敗しました: \(error.localizedDescription)")
                            }
                        }
                    }


                    Spacer()
                    
                    Divider()
                    Toggle("通知設定", isOn: $userInfoManager.isNotificationOn)
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
                    Button {
                        // 共有先はAppStoreのアプリ画面（未実装）
                    } label: {
                        HStack {
                            Text("共有する")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundStyle(.black)
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
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    SettingView()
}
