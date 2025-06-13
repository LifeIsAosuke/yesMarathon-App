//
//  AchievedView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

import SwiftUI
import SwiftData

struct AchievedView: View {
    
    // データベースからDayChangeManagerの情報を取得
    @Query private var dayChangeManager: [DayChangeManager]
    @State private var currentManager: DayChangeManager?
    //UserInfoManager型のインスタンスを全て取得
    @Query private var userInfoManager: [UserInfoManager]
    @State private var currentUserInfo: UserInfoManager?
    
    //　背景色
    @State private var backgroundColor: Color = Color.white
    
    // 文字の色
    @State private var textColor: Color = Color.white
    
    // アイコンのアニメーション用変数
    @State private var iconScale: CGFloat = 0.0
    
    // アニメーションを適応するかの管理用変数
    @State private var isAnimated: Bool = false
    
    // 設定画面へ画面遷移管理用のフラグ変数
    @State private var isShowSettingView: Bool = false
    
    let backgroundGradientColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // 背景
                backgroundColor.ignoresSafeArea()
                
                VStack {
                    HStack {
                        
                        Button {
                            isShowSettingView = true
                        } label: {
                            if let userIconData = currentUserInfo?.userIconData, let uiImage = UIImage(data: userIconData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().stroke(.black, lineWidth: 1)
                                    }
                                    .shadow(radius: 5)
                                    .padding()
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundStyle(Color.yesOrange)
                                    .scaleEffect(3)
                                    .padding()
                            }
                        }
                        .padding()
                        .sheet(isPresented: $isShowSettingView) {
                            SettingView()
                        }
                        
                        Spacer()
                        
                        
                        // YESログボタン
                        NavigationLink {
                            YesLogView()
                        } label: {
                            VStack {
                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 45))
                                
                                Text("YESログ")
                                    .font(.system(size: 15))
                            }
                            .padding()
                            .foregroundStyle(Color.yesOrange)
                            .shadow(radius: 3)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                   
                
                VStack {
                    
                    Text("本日のYES達成！")
                        .foregroundStyle(textColor)
                        .font(.title)
                        .bold()
                        .padding()
                        .shadow(radius: 2)
                    
                    Image("achievedIcon")
                        .resizable()
                        .frame(width: 237, height: 258)
                        .padding()
                        .scaleEffect(iconScale)
                        // HomeViewから画面遷移後アニメーション開始
                        .onAppear {
                            withAnimation (.easeOut(duration: 2.0)) {
                                iconScale = 1.0
                            }
                        }
                    
                    Text("また明日も頑張ろう")
                        .foregroundStyle(textColor)
                        .bold()
                        .padding()
                }
                .padding()
            }
        }
        // 画面遷移後アニメーション開始
        .onAppear {
            
            currentManager = dayChangeManager.first
            currentUserInfo = userInfoManager.first
            
            backgroundColor = Color.yesOrange
            
            // 2秒後にアニメーションを開始
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                // 背景色を徐々に白にするアニメーション
                withAnimation(.easeInOut(duration: 1.0)) {
                    backgroundColor = Color.white
                    textColor = Color.black
                }
            }
        }
    }
}

#Preview {
    AchievedView()
}
