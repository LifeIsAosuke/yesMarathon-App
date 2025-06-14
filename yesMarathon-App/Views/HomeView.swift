//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/28.
//

import SwiftUI
import SwiftData
import PhotosUI
import WidgetKit
import OpenAI


extension String {
    // 全ての文字の間に Unicode WORD JOINER を挿入する
    func wordJoined() -> String {
        let wordJointer = "\u{2060}"
        return map { String($0) }.joined(separator: wordJointer)
    }
}



struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var dayChangeManager: DayChangeManager
    
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
    @State private var yesSuggestion = YesSuggestion()
    //------------------------------------------------------------
    
    // Yesボタンタップ時のアニメーション起動フラグ変数
    @State private var animationFlag: Bool = false
    
    
    @State private var responseText: String = "Loading..."
    
    // 設定画面へ画面遷移管理用のフラグ変数
    @State private var isShowSettingView: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack { // 全体のVStack
                    
                    // 本日のYESラベル
                    VStack {
                        
                        HStack {
                            Text("本日のYES")
                                .foregroundColor(.black)
                                .opacity(0.5)
                                .bold()
                            
                            
                            
                            Spacer()
                            
                            if !isYesButtonTapped {
                                
                                // シャッフルボタン
                                Button{
                                    // ChatGPT APIを呼び出し
                                    Task {
                                        await handleShuffleButtonTap()
                                    }
                                    
                                } label: {
                                    
                                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle")
                                        .foregroundColor(Color.yesOrange)
                                        .font(.system(size: 30))
                                        .shadow(radius: 1)
                                    
                                    
                                }
                                
                                // 自分で決めるボタン
                                Button {
                                    // Initialize editingText with the current yesLabel when presenting
                                    editingText = ""
                                    isPresented = true
                                } label: {
                                    
                                    Image(systemName: "pencil.circle")
                                        .foregroundColor(Color.yesOrange)
                                        .font(.system(size: 30))
                                        .shadow(radius: 1)
                                    
                                }
                                .alert("本日のYESを入力", isPresented: $isPresented, actions: {
                                    TextField("\(yesSuggestion.random())", text: $editingText)
                                    
                                    
                                    Button{
                                        // 変更があればYESラベルに登録
                                        if !editingText.isEmpty {
                                            yesLabel = editingText
                                        }
                                        
                                        modifyYesLabel() // YESラベルを変更
                                        
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
                        
                        Divider()
                        
                        // YESお題
                        Text(yesLabel.wordJoined())
                            .font(.system(size:25))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                    // 影をつける
                    .shadow(radius: 2)
                    
                    Spacer()
                    Spacer()
                    
                    
                    
                    if !isYesButtonTapped{
                        // YESボタン
                        Button() {
                            // アニメーション開始
                            animationFlag.toggle()
                            // 画面切り替え
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationFlag.toggle()
                                isYesButtonTapped.toggle()
                            }
                            
                        } label: {
                            Text("YES!")
                                .font(.system(size: 90))
                                .bold()
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .foregroundStyle(Color.yesOrange)
                                        .frame(width: 310, height: 310)
                                        .overlay {
                                            Circle().stroke(Color.yesYellow, lineWidth: 2)
                                        }
                                        .shadow(radius: 5)
                                        .scaleEffect(animationFlag ? 1.1 : 1.0)
                                }
                            
                        }
                        .scaleEffect(animationFlag ? 1.05 : 1.0)
                        
                        
                    } else {
                        ScrollView {
                            VStack {
                                Divider()
                                
                                // コメント入力部分
                                
                                HStack {
                                    Image(systemName: "text.justify.left")
                                        .frame(width: 25, height: 25)
                                    Text("コメント")
                                        .font(.system(size: 14))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .bold()
                                
                                ZStack {
                                    
                                    TextEditor(text: $comment)
                                        .scrollContentBackground(Visibility.hidden)
                                    
                                    if comment.isEmpty {
                                        HStack {
                                            Text("今日のYESな瞬間を記録")
                                                .opacity(0.3)
                                            
                                            Spacer()
                                        }
                                        
                                    }
                                }
                                .padding()
                                
                                
                                
                                Divider()
                                
                                // YES評価
                                Group {
                                    HStack {
                                        Image(systemName: "star")
                                        Text("YES評価")
                                            .font(.system(size: 14))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .bold()
                                    
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
                                                        .shadow(radius: 1)
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
                                                    .bold()
                                                
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
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 40)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // 設定画面へ
                    if !isYesButtonTapped {
                        VStack {
                            
                            Spacer()
                            
                            
                            Button {
                                isShowSettingView = true
                            } label: {
                                
                                Image(systemName: "gearshape")
                                    .font(.system(size: 25))
                                    .bold()
                                    .foregroundStyle(Color.yesOrange)
                                    .shadow(radius: 1)
                            }
                            .padding()
                            .sheet(isPresented: $isShowSettingView) {
                                SettingView()
                            }
                            
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // YesLogへ
                    VStack {
                        
                        Spacer()
                        
                        
                        if !isYesButtonTapped {
                            // YESログボタン
                            NavigationLink {
                                YesLogView()
                            } label: {
                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 30))
                            }
                            .foregroundStyle(Color.yesOrange)
                            .shadow(radius: 3)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            yesLabel = dayChangeManager.yesTitle
        }
    }
    
    
    // SwiftDataに保存するための関数
    private func addData() {
        // 必須項目の検証
        guard !yesLabel.isEmpty else {
            print("HomeView: お題が未入力です")
            return
        }
        // 入力事項をデータベースに保存
        let newData = EachDayData(yesTitle: yesLabel, day: today, comment: comment, yesEvaluation: yesEvaluation, imageData: imageData)
        do {
            modelContext.insert(newData)
            // dayChangeManagerのisTrueを更新し、保存
            dayChangeManager.isTrue = true
            try modelContext.save()
            print("HomeView: 新たなeachDayDataが追加されました")
            
        } catch {
            print("HomeView: データの保存に失敗しました: \(error.localizedDescription)")
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
    
    // YESラベルを変更した時に呼ばれる
    private func modifyYesLabel() {
        // データベースに本日のYESの変更内容を保存
        dayChangeManager.yesTitle = yesLabel
        
        // widgetを更新
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func handleShuffleButtonTap() async {
        await fetchOpenAIResponse()
        yesLabel = responseText
        modifyYesLabel()
    }
    
    // ChatGPT API 呼び出し
    @MainActor
    func fetchOpenAIResponse() async {
        
        guard let randomPrompt = prompts.randomElement() else { return }
        
        // API Keyを取得
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !apiKey.isEmpty else {
            print("API Keyが設定されていません")
            return
        }
        let openAI = OpenAI(apiToken: apiKey)
        
        guard let message = ChatQuery.ChatCompletionMessageParam(role: .user, content: randomPrompt) else { return }
        
        let query = ChatQuery(messages: [message], model: .gpt4_o)
        
        do {
            let result = try await openAI.chats(query: query)
            if let firstChoice = result.choices.first, let content = firstChoice.message.content {
                responseText = content
                print("API応答: \(responseText)")
            } else {
                handleAPIError()
            }
        } catch {
            print("API呼び出しエラー: \(error.localizedDescription)")
            handleAPIError()
        }
    }
    
    private func handleAPIError() {
        responseText = YesSuggestion().random()
        print("Open API の実行に失敗しました。")
    }
    
}

extension Bundle {
    func value(for key: String, inPlistNamed plistName: String) -> String? {
        guard let url = self.url(forResource: plistName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
        else {
            return nil
        }
        return plist[key] as? String
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [EachDayData.self])
}

