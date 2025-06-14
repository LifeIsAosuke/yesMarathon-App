//
//  AchievedView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

import SwiftUI
import SwiftData

struct AchievedView: View {
    
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // 設定画面へ
                    
                    VStack {
                        
                        Spacer()
                        
                        
                        Button {
                            isShowSettingView = true
                        } label: {
                            
                            Image(systemName: "gearshape")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundStyle(Color.yesOrange)
                                .shadow(radius: 1)
                        }
                        .padding()
                        .sheet(isPresented: $isShowSettingView) {
                            SettingView()
                        }
                        
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // YesLogへ
                    VStack {
                        
                        Spacer()
                        
                        // YESログボタン
                        NavigationLink {
                            YesLogView()
                        } label: {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: 30))
                        }
                        .foregroundStyle(Color.yesOrange)
                        .shadow(radius: 3)
                        
                    }
                }
            }
        }
        // 画面遷移後アニメーション開始
        .onAppear {
            
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
        .modelContainer(for: [EachDayData.self])
}
