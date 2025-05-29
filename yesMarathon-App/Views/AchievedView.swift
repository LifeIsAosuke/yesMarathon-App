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
    @State private var backgroundColor: Color = Color(red: 255 / 255.0, green: 123 / 255.0, blue: 0 / 255.0)
    
    var body: some View {
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
                
                Text("また明日も頑張ろう")
                    .bold()
                    .padding()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        // ナビゲーション遷移後アニメーション開始
        .onAppear {
            // 画面遷移後、３秒後にアニメーションを開始
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
