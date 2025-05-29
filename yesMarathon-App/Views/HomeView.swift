//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI

struct HomeView: View {
    
    let yesSuggestion = YesSuggestion()
    
    // YESお題のラベル
    @State private var yesLabel: String
    
    init() {
        yesLabel = yesSuggestion.random()
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                Text("本日のYES")
                    .foregroundColor(Color(.sRGB, red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                //お題ラベル
                HStack {
                    Text(yesLabel)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 268, height: 180, alignment: .leading)
                    
                    Button(action: {
                        
                        yesLabel = yesSuggestion.random()
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0))
                                    .opacity(80.5)
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrow.trianglehead.2.clockwise")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24))
                            }
                            Text("シャッフル")
                                .foregroundColor(.black)
                                .font(.system(size: 10))
                        }
                    }
                   
                }
                Spacer()
                // YESボタン
                NavigationLink {
                    AchievedView()
                } label: {
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
        }
        .padding()
        
    }
}

#Preview {
    HomeView()
}
