//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI
import SwiftData
import PhotosUI

struct HomeView: View {
    
    // DayChangeManagerの情報を取得（配列で取得し状態管理）-----
    @Environment(\.modelContext) private var modelContext
    @Query private var dayChangeManager: [DayChangeManager]
    
    @State private var currentManager: DayChangeManager?
    // --------------------------------------------------
    
    //-----入力部分に使う変数--------------------------------------
    
    // 日付
    @State private var today : Date = Date()
    
    // 入力部分に関する変数
    @State private var comment: String = ""
    
    // YES評価のスターアイコンに対応（１だったらその部分がfillアイコンに変わる）
    @State private var stars: [Int] = [1, 1, 1, 0, 0]
    @State private var yesEvaluation: Int = 3
    
    // 画像に関する変数
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    // YESボタンタップしたかどうかを管理する変数
    @State private var isYesButtonTapped: Bool = false
    
    // YESお題の中身
    @State private var yesLabel: String = "デフォルト"
    
    // アラート画面の管理
    @State private var isPresented: Bool = false
    @State private var editingText: String = ""
    //------------------------------------------------------------
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                    }
                    
                    VStack {
                        
                        Text("本日のYES")
                            .foregroundColor(.black)
                            .opacity(0.5)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 50)
                            .padding(.top, 60)
                        
                        //お題ラベル
                        HStack {
                            
                            // YESお題
                            Text(yesLabel)
                                .font(.title)
                                .bold()
                                .frame(width: 300, height: 180)
                            
                            
                            if !isYesButtonTapped {
                                VStack {
                                    // シャッフルボタン
                                    Button{
                                        yesLabel = YesSuggestion().random()
                                        currentManager?.EditYesTitle(yesTitle: yesLabel)
                                        do {
                                            try modelContext.save()
                                            print("\(currentManager?.showYesTitle())")
                                        } catch {
                                            print("シャッフルによるデータベースの保存に失敗しました")
                                        }
                                    } label: {
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .foregroundColor(Color.yesLightGray)
                                                    .opacity(0.8)
                                                    .frame(width: 48, height: 48)
                                                Image(systemName: "arrow.trianglehead.2.clockwise")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 24))
                                            }
                                            Text("シャッフル")
                                                .foregroundColor(.black)
                                                .font(.system(size: 10))
                                        }
                                    }
                                    
                                    Button {
                                        // Initialize editingText with the current yesLabel when presenting
                                        editingText = yesLabel
                                        isPresented = true
                                    } label: {
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .foregroundColor(Color.yesLightGray)
                                                    .opacity(0.8)
                                                    .frame(width: 48, height: 48)
                                                Image(systemName: "pencil")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 24))
                                            }
                                            Text("自分で決める")
                                                .foregroundColor(.black)
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .alert("本日のYESを入力", isPresented: $isPresented, actions: {
                                        TextField("本日のYES", text: $editingText)

                                        
                                        Button{
                                            // Only update yesLabel if editingText is not empty
                                            if !editingText.isEmpty {
                                                yesLabel = editingText
                                            }
                                            
                                            
                                            currentManager?.EditYesTitle(yesTitle: yesLabel)
                                            do {
                                                try modelContext.save()
                                            } catch {
                                                print("自分で決めるボタンでの登録エラー")
                                            }
                                            
                                            // アラート画面を閉じる
                                            isPresented = false
                                        } label: {
                                            Text("登録する")
                                                .bold()
                                        }
                                        
                                        Button("キャンセル", role: .cancel) {
                                            editingText = ""
                                            isPresented = false
                                        }
                                    })
                                }
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
                                    
                                    TextField("今日のYESな瞬間を記録", text: $comment)
                                        .frame(minHeight: 40, maxHeight: 120)
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
                                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .padding()
                                } else {
                                    PhotosPicker(selection: $selectedItem) {
                                        HStack {
                                            HStack {
                                                Image(systemName: "photo")
                                                Text("画像を追加")
                                                
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            
                                            Image(systemName: "chevron.right")
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .frame(minHeight: 40)
                                        .padding()
                                    }
                                    .foregroundColor(.black)
                                    .onChange(of: selectedItem) { newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                imageData = data
                                            }
                                        }
                                    }
                                }
                                
                                
                                // 登録ボタン
                                Button(action: {addData()}) {
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
                                Button (action:{cansel()}) {
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
        .onAppear {
            currentManager = dayChangeManager.first
            yesLabel = currentManager?.showYesTitle() ?? "currentManagerの取得に失敗しているよ"
        }
    }
    
    // SwiftDataに保存するための関数
    private func addData() {
        // 必須項目の検証
        guard !yesLabel.isEmpty else {
            print("お題が未入力です")
            return
        }
        // 入力事項をデータベースに保存
        let newData = EachDayData(yesTitle: yesLabel, day: today, comment: comment, yesEvaluation: yesEvaluation, imageData: imageData)
        do {
            try modelContext.insert(newData)
            // dayChangeManagerのisTrueを更新し、保存
            if let manager = dayChangeManager.first {
                manager.isTrue = true
                try? modelContext.save()
//                modelContext.save()
            } else {
                print("dayChangeMnagerのデータが取得できません")
            }
        } catch {
            print("データの保存に失敗しました: \(error.localizedDescription)")
        }
    }
    
    // キャンセルボタンタップで各パラメータの初期化
    private func cansel() {
        comment = ""
        yesEvaluation = 3
        stars = [1, 1, 1, 0, 0]
        imageData = nil
        isYesButtonTapped.toggle()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [DayChangeManager.self, EachDayData.self])
}

