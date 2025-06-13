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
    @Attribute var userIconData: Data?
    @Attribute var userName: String = "ユーザーネーム"
    @Attribute var isNotificationOn: Bool = false
    
    init() {
        self.userIconData = nil
        self.userName = "ユーザーネーム"
        self.isNotificationOn = false
    }
    
    var image: UIImage? { // UIImage型のプロパティ
        guard let userIconData = userIconData else { return nil }
        return UIImage(data: userIconData)
    }
}
