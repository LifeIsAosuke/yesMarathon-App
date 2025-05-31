//
//  EachDayData.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/31.
//

import Foundation
import SwiftData

@Model
class EachDayData {
    var yesTitle: String
    var day: Date
    var comment: String
    var yesEvaluation: Int
    var image: Data? // 画像をどうデータに落とし込むかは要検討
    var isAchieved: Bool
    
    init(yesTitle: String, day: Date, comment: String, yesEvaluation: Int, image: Data? = nil) {
        self.yesTitle = yesTitle
        self.day = day
        self.comment = comment
        self.yesEvaluation = yesEvaluation
        self.image = image
        self.isAchieved = false
    }
}
