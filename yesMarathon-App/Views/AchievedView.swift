//
//  AchievedView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

import SwiftUI

struct AchievedView: View {
    
    // アニメーションフラグ変数(Home画面から遷移したときtrueに)
    @State private var isAnimating: Bool = false
    
    //　背景色
    @State private var backgroundColor: Color = Color.white
    
    // アイコンのアニメーション用変数
    @State private var iconScale: CGFloat = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // 背景
                backgroundColor.ignoresSafeArea()
                
                VStack {
                    
                    Text("本日のYES達成！")
                        .font(.title)
                        .bold()
                        .padding()
                    
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
                        .bold()
                        .padding()
                }
                .padding()
                
                // YESログボタン
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink {
                            YesLogView()
                        } label: {
                            VStack {
                                Image(systemName: "calendar.badge.checkmark")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                Text("YESログ")
                                    .font(.caption)
                            }
                            .foregroundColor(Color.yesOrange)
                            .padding()
                        }
                    }
                    Spacer()
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
                }
            }
        }
    }
}

#Preview {
    AchievedView()
}
