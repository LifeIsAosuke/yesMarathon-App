//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI
import SwiftData

extension Color {
    // オレンジ色
    static let yesOrange = Color(red: 255 / 255.0, green: 161 / 255.0, blue: 0 / 255.0)
    // 灰色
    static let yesLightGray = Color(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0)
    
    // 黄色
    static let yesYellow = Color(red: 253 / 255.0, green: 202 / 255.0, blue: 0 / 255.0)
}

struct HomeView: View {
    
    //入力部分に関する変数
    @State private var comment: String = ""
    @State private var stars: [Int] = [1, 1, 1, 0, 0] //YES評価のスターアイコンに対応（１だったらその部分がfillアイコンに変わる）
    @State private var yesEvaluation: Int = 3
    @State private var image: Data? = nil
    
    // YESボタンタップしたかどうかを管理する変数
    @State private var isYesButtonTapped: Bool = false
    
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
                    
                    if !isYesButtonTapped{
                        // YESボタン
                        Button() {
                            isTrue = true
                            isYesButtonTapped.toggle()
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
                        
                    } else {
                        VStack {
                            
                            Divider()
                            
                            // コメント入力部分
                            Group {
                                HStack {
                                    Image(systemName: "text.justify.left")
                                        .frame(width: 25, height: 25)
                                    Text("コメント")
                                        .font(.system(size: 14))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                TextField("", text: $comment)
                            }
                            
                            Divider()
                            
                            // YES評価
                            Group {
                                HStack {
                                    Image(systemName: "star")
                                    Text("YES評価")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)

                                HStack(alignment: .top) {
                                    // 評価１
                                    Button(action: {
                                        stars[0] = 1
                                        stars[1] = 0
                                        stars[2] = 0
                                        stars[3] = 0
                                        stars[4] = 0
                                        yesEvaluation = 1
                                    }) {
                                        VStack {
                                            if stars[0] == 0{
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            } else {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color.yesYellow)
                                            }
                                            Text("イマイチ")
                                                .font(.caption)
                                        }
                                    }
                                    // 評価２
                                    Button(action: {
                                        stars[0] = 1
                                        stars[1] = 1
                                        stars[2] = 0
                                        stars[3] = 0
                                        stars[4] = 0
                                        yesEvaluation = 2
                                    }) {
                                        VStack {
                                            if stars[1] == 0{
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            } else {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color.yesYellow)
                                            }
                                        }
                                    }
                                    // 評価３
                                    Button(action: {
                                        stars[0] = 1
                                        stars[1] = 1
                                        stars[2] = 1
                                        stars[3] = 0
                                        stars[4] = 0
                                        yesEvaluation = 3
                                    }) {
                                        VStack {
                                            if stars[2] == 0{
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            } else {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color.yesYellow)
                                            }
                                            Text("イイネ!")
                                                .font(.caption)
                                        }
                                    }
                                    // 評価４
                                    Button(action: {
                                        stars[0] = 1
                                        stars[1] = 1
                                        stars[2] = 1
                                        stars[3] = 1
                                        stars[4] = 0
                                        yesEvaluation = 4
                                    }) {
                                        VStack {
                                            if stars[3] == 0{
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            } else {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color.yesYellow)
                                            }
                                        }
                                    }
                                    // 評価５
                                    Button(action: {
                                        stars[0] = 1
                                        stars[1] = 1
                                        stars[2] = 1
                                        stars[3] = 1
                                        stars[4] = 1
                                        yesEvaluation = 5
                                    }) {
                                        VStack {
                                            if stars[4] == 0{
                                                Image(systemName: "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            } else {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color.yesYellow)
                                            }
                                            Text("バチイケ!!")
                                                .font(.caption)
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .foregroundColor(.black)
                        }
                        .padding()
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
