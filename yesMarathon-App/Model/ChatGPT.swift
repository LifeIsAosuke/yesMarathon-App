//
//  ChatGPT.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/15.
//

import SwiftUI
import OpenAI

class ChatGPT: ObservableObject {
    
    private var responseText: String = "Loading..."
    
    // ChatGPT API 呼び出し
    @MainActor
    public func fetchOpenAIResponse() async {
        
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
    
    func getResponseText() -> String {
        return responseText
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
