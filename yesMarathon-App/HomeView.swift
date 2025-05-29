//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("本日のYES")
                .foregroundColor(Color(.sRGB, red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            //お題ラベル
            HStack {
                Text("自分らしくないことを1つやってみる")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Button(action: {}) {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundColor(Color(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0))
                                .opacity(0.5)
                                .frame(width: 44, height: 44)
                            Image(systemName: "arrow.trianglehead.2.clockwise")
                                .foregroundColor(.black)
                                .font(.system(size: 24))
                        }
                        Text("変更する")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                    }
                }
                .padding()
            }
            Spacer()
            // YESボタン
            Button(action: {}) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(red: 255 / 255.0, green: 161 / 255.0, blue: 0 / 255.0))
                        .frame(width: 320, height: 320)
                    Circle()
                        .foregroundColor(Color(red: 255 / 255.0, green: 123 / 255.0, blue: 0 / 255.0))
                        .frame(width: 310, height: 310)
                    Text("YES!")
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    HomeView()
}
