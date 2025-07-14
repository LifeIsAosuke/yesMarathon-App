//
//  ChatGPT.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/15.
//

import SwiftUI
import OpenAI

class ChatGPT: ObservableObject {
    
    @AppStorage("responseText") var responseText: String = "Loading..."
    
    
    
    // ChatGPT API 呼び出し
    @MainActor
    public func fetchOpenAIResponse(categoryValue: Int) async {
        
        // プロンプトの選定
        let randomPrompt: String
        
        if prompts.indices.contains(categoryValue) { // カテゴリーごとに選定
            randomPrompt = prompts[categoryValue].randomElement() ?? ""
        } else if categoryValue == 6 { // ランダムに選択
            randomPrompt = prompts.flatMap { $0 }.randomElement() ?? ""
        } else { // エラー処理
            randomPrompt = prompts.flatMap { $0 }.randomElement() ?? ""
            print("カテゴリー選定エラーです。全体からランダムに選択しました。")
        }
        
        
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
                responseText = YesSuggestion().random()
                print("Open API の実行に失敗しました。")
            }
        } catch {
            responseText = YesSuggestion().random()
            print("Open API の実行に失敗しました。")
        }
    }

    
    public func getResponseText() -> String {
        return responseText
    }
    
    // 達成画面の一言コメント
    @MainActor
    public func achieveComment(yesTitle: String) async {
        
        let prompt = "\(yesTitle)！こんなYESなことをした自分を50字以内で精一杯に褒めて！"
        
        // API Keyを取得
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !apiKey.isEmpty else {
            print("API Keyが設定されていません")
            return
        }
        let openAI = OpenAI(apiToken: apiKey)
        
        guard let message = ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt) else { return }
        
        let query = ChatQuery(messages: [message], model: .gpt4_o)
        
        do {
            let result = try await openAI.chats(query: query)
            if let firstChoice = result.choices.first, let content = firstChoice.message.content {
                responseText = content
                print("API応答: \(responseText)")
            } else {
                responseText = "また明日もYESな1日を！"
            }
        } catch {
            print("API呼び出しエラー: \(error.localizedDescription)")
            responseText = "また明日もYESな1日を！"
        }
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
