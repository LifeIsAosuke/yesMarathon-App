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
    @Attribute(.unique)
    var id: UUID
    var yesTitle: String
    var day: Date
    var comment: String
    var yesEvaluation: Int
    var imageData: Data?
    var isAchieved: Bool
    
    init(
        yesTitle: String,
        day: Date,
        comment: String,
        yesEvaluation: Int,
        imageData: Data? = nil,
        isAchieved: Bool = false
    ) {
        self.id = UUID()
        self.yesTitle = yesTitle
        self.day = day
        self.comment = comment
        self.yesEvaluation = yesEvaluation
        self.imageData = imageData
        self.isAchieved = isAchieved
    }
}
