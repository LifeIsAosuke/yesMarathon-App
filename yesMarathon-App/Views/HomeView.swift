//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI

extension Color {
    // オレンジ色
    static let yesOrange = Color(red: 255 / 255.0, green: 161 / 255.0, blue: 0 / 255.0)
    // 灰色
    static let yesLightGray = Color(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0)
}

struct HomeView: View {
    
    // YESボタンタップ後の画面遷移を管理する変数
    @Binding var isTrue: Bool
    // YESお題の中身
    @Binding var yesLabel: String
    // 画面更新後の初期化
    init(isTrue: Binding<Bool>, yesLabel: Binding<String>) {
        self._isTrue = isTrue
        self._yesLabel = yesLabel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // YESログボタン
                ZStack {
                    NavigationLink {
                        YesLogView()
                    } label: {
                        VStack {
                            Image(systemName: "calendar.badge.checkmark")
                                .resizable()
                                .frame(width: 48, height: 48)
                            Text("YESログ")
                        }
                        .foregroundColor(Color.yesOrange)
                        .frame(width: 100, height: 100, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                
                VStack {
                    
                    Text("本日のYES")
                        .foregroundColor(Color.yesLightGray)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .padding(.top, 40)
                    
                    //お題ラベル
                    HStack {
                        
                        // YESお題
                        Text(yesLabel)
                            .font(.title)
                            .bold()
                        //                    .padding()
                            .frame(width: 300, height: 180)
                        
                        // シャッフルボタン
                        Button(action: {
                            yesLabel = YesSuggestion().random()
                        }) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color.yesLightGray)
                                        .opacity(0.8)
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
                        .contentShape(Rectangle())
                        .accessibilityLabel("お題をシャッフルします")
                    }
                    .padding([.leading, .trailing], 16)
                    
                    // YESボタン
                    Button() {
                        isTrue = true
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.yesOrange)
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
        }
    }
}

#Preview {
    HomeView(isTrue: .constant(false), yesLabel: .constant(YesSuggestion().random()))
}
