//
//  Untitled.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

// 本日のYESの提案集
let yesChallenges: [String] = [
    "知らない人に笑顔で「こんにちは」と言ってみる",
    "いつもと違う道で帰ってみる",
    "コンビニで“普段買わない商品”を1つ選ぶ",
    "スマホを30分間置いて、音のない時間を過ごす",
    "SNSで「いいね」だけじゃなく、一言コメントをつける",
    "誰かの“すごいところ”を口に出して伝える",
    "今日やるべきことを“声に出して宣言”してから始める",
    "夜、寝る前に「今日の良かったこと」を3つ書き出す",
    "「いつかやりたい」と思ってることを1つ“検索だけ”してみる",
    "“YESチャレンジ中”であることを誰かに宣言してみる"
]

class YesSuggestion {
    
    // yesChallengesの配列数を保持
    private let yesDatas: Int = yesChallenges.count
    
    // yesChallengesの中からランダムに1つ取り出す
    public func random() -> String {
        let randomNumber = Int.random(in:0..<yesDatas)
        return yesChallenges[randomNumber]
    }
}
