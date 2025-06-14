//
//  DayChangeManager.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI
import SwiftData

@Model
final class DayChangeManager {
    @Attribute var isTrue: Bool = false
    @Attribute var yesTitle: String
    @Attribute var lastLoginDate: Date?
    
    init(yesTitle: String) {
        self.isTrue = false
        self.yesTitle = yesTitle
        self.lastLoginDate = nil
    }
}
