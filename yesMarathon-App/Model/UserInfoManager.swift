//
//  UserInfoManager.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import Foundation
import SwiftData
import UIKit

@Model
final class UserInfoManager: ObservableObject {
    private var userIcon: Data?
    private var userName: String
    private var isNotificationOn: Bool = false
    
    init(userIcon: Data? = nil) {
        self.userIcon = userIcon
        self.userName = "ユーザーネーム"
        self.isNotificationOn = false
    }
    
    var image: UIImage? {
        guard let userIcon = userIcon else { return nil }
        return UIImage(data: userIcon)
    }
    
    // アイコンの変更
    public func setUserIcon(_ iconData: Data) {
        self.userIcon = iconData
    }
    
    // ユーザー名の設定
    public func setUserName(_ name: String) {
        self.userName = name
    }
    
    // 通知設定の変更
    public func toggleNotification() {
        self.isNotificationOn.toggle()
    }
}
