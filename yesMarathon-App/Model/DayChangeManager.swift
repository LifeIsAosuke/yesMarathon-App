//
//  DayChangeManager.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI
import SwiftData

final class DayChangeManager: ObservableObject {
    
    @AppStorage("isTrue") var isTrue: Bool = false
    @AppStorage("yesTitle") var yesTitle: String = "今日は”No”と言わないようにする"
    @AppStorage("yesTitle") var lastLoginDate: Date?
    
}
