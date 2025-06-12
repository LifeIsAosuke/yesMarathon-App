//
//  SettingView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                
                Image(systemName: "person.crop.circle")
                    .scaleEffect(6)
                
                Spacer()
                
                Text("userName")
                
                Spacer()
                
                Text("通知設定")
                Text("アプリの評価")
                Text("")
                Text("このアプリを共有する")
                
                Spacer()
            }
        }
        
        
        
    }
}

#Preview {
    SettingView()
}
