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
    @Attribute private var yesTitle: String
    
    init(yesTitle: String) {
        self.isTrue = false
        self.yesTitle = yesTitle
    }
    
    // YESタイトルの表示
    public func showYesTitle() -> String {
        return yesTitle
    }
    
    // 自分で決めるボタンタップで呼び出し
    public func EditYesTitle(yesTitle: String) {
        self.yesTitle = yesTitle
    }
}
