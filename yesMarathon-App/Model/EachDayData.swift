//
//  EachDayData.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/31.
//

import Foundation
import SwiftData
import UIKit

@Model
final class EachDayData {
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
    ) {
        self.id = UUID()
        self.yesTitle = yesTitle
        self.day = day
        self.comment = comment
        self.yesEvaluation = yesEvaluation
        self.imageData = imageData
        self.isAchieved = false
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}
