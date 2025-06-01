//
//  DetailView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("2025年5月26日")
                    .padding()
                
                Text("自分らしくないことを１つやってみる")
                    .font(.title)
                
                Divider()
                
                Group {
                    HStack {
                        Image(systemName: "text.justify.left")
                            .frame(width: 25, height: 25)
                        Text("コメント")
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Text("河川敷までランニングしてみた！どっと疲れたけど気分爽快！久々の運動も悪くないな。今日はぐっすり眠れそう")
                        .frame(height: 40)
                        .padding()
                }
                
                Divider()
                
                // YES評価
                Group {
                    HStack {
                        Image(systemName: "star")
                        Text("YES評価")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    HStack(alignment: .top) {
                        
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                }
                .foregroundColor(.black)
                
                Divider()
                
                HStack {
                    Image(systemName: "photo")
                    Text("画像")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            }
        }
    }
}

#Preview {
    DetailView()
}
