//
//  Untitled.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

class YesSuggestion {
    
    // yesChallengesの配列数を保持
    private let yesDatas: Int = yesChallenges.count
    
    // yesChallengesの中からランダムに1つ取り出す
    public func random() -> String {
        let randomNumber = Int.random(in:0..<yesDatas)
        return yesChallenges[randomNumber]
    }
}
