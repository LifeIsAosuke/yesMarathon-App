//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI
import SwiftData
import PhotosUI

extension Color {
    // 黄オレンジ色
    static let yesYellowOrange = Color(red: 255 / 255.0, green: 161 / 255.0, blue: 0 / 255.0)
    
    // オレンジ色
    static let yesOrange = Color(red: 255 / 255.0, green: 123 / 255.0, blue: 0 / 255.0)
    
    // 灰色
    static let yesLightGray = Color(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0)
    
    // 黄色
    static let yesYellow = Color(red: 253 / 255.0, green: 202 / 255.0, blue: 0 / 255.0)
}

struct HomeView: View {
    
    //データの永続化用変数
    @Environment(\.modelContext) private var modelContext
    
    // 日付
    @State private var today : Date = Date()
    
    //入力部分に関する変数
    @State private var comment: String = ""
    
    //YES評価のスターアイコンに対応（１だったらその部分がfillアイコンに変わる）
    @State private var stars: [Int] = [1, 1, 1, 0, 0]
    @State private var yesEvaluation: Int = 3
    
    // 画像に関する変数
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    // YESボタンタップしたかどうかを管理する変数
    @State private var isYesButtonTapped: Bool = false
    
    // YESボタンタップ後の画面遷移を管理する変数
    @Binding var isTrue: Bool
    
    // YESお題の中身
    @Binding var yesLabel: String
    
    // テキストフィールドにフォーカスがあったているか管理
    @FocusState private var focus: Bool

    
    
    // 画面更新後の初期化
    init(isTrue: Binding<Bool>, yesLabel: Binding<String>) {
        self._isTrue = isTrue
        self._yesLabel = yesLabel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if !isYesButtonTapped{
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
                }
                
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
                            .frame(width: 300, height: 180)
                        
                        // シャッフルボタン
                        if !isYesButtonTapped {
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
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                    
                    if !isYesButtonTapped{
                        // YESボタン
                        Button() {
                            isYesButtonTapped.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.yesYellowOrange)
                                    .frame(width: 320, height: 320)
                                Circle()
                                    .foregroundColor(Color.yesOrange)
                                    .frame(width: 310, height: 310)
                                Text("YES!")
                                    .font(.system(size: 90))
                                    .bold()
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
                                .padding()
                                
                                TextField("", text: $comment, axis: .vertical)
                                    .focused(self.$focus)
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
                                    ForEach(0..<5) { index in
                                        Button(action: {
                                            for i in 0...index {
                                                stars[i] = 1
                                            }
                                            for i in (index+1)..<5 {
                                                stars[i] = 0
                                            }
                                            yesEvaluation = index + 1
                                        }) {
                                            VStack {
                                                Image(systemName: stars[index] == 1 ? "star.fill" : "star")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(stars[index] == 1 ? Color.yesYellow : .gray)
                                                if index == 0 { Text("イマイチ").font(.caption) }
                                                if index == 2 { Text("イイネ!").font(.caption) }
                                                if index == 4 { Text("バチイケ!!").font(.caption) }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                
                            }
                            .foregroundColor(.black)
                            
                            Divider()
                            
                            // 画像追加
                            PhotosPicker(
                                selection: $selectedItem
                            ) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("画像を追加")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .foregroundColor(.black)
                            .frame(height: 60)
                            .padding()
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        imageData = data
                                    }
                                }
                            }
                            
                            
                            // 登録ボタン
                            Button(action: {
                                
                                // 必須項目の検証
                                guard !yesLabel.isEmpty else {
                                    print("お題が未入力です")
                                    return
                                }
                                
                                // 入力事項をデータベースに保存
                                let newData = EachDayData(
                                    yesTitle: yesLabel,
                                    day: today,
                                    comment: comment,
                                    yesEvaluation: yesEvaluation,
                                    imageData: imageData
                                )
                                // データが正しく保存されていれば画面遷移
                                do {
                                    modelContext.insert(newData)
                                    isTrue = true
                                } catch {
                                    print("データの保存に失敗しました: \(error.localizedDescription)")
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.yesOrange)
                                        .frame(height: 60)
                                        .cornerRadius(10)
                                    Text("登録する")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // キャンセル
                            Button (action: {
                                //コメントを初期化
                                comment = ""
                                //YES評価を初期化
                                yesEvaluation = 3
                                
                                stars[0] = 1
                                stars[1] = 1
                                stars[2] = 1
                                stars[3] = 0
                                stars[4] = 0
                                
                                isYesButtonTapped.toggle()
                            }) {
                                Text("キャンセル")
                            }
                            .foregroundColor(.black)
                            .padding()
                            
                            
                        }
                        .padding(40)
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
