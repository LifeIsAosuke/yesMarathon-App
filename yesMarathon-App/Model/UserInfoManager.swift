//
//  UserInfoManager.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/12.
//

import SwiftUI
import Foundation
import SwiftData
import UIKit

final class UserInfoManager: ObservableObject {
    @AppStorage("userIconData") var userIconData: Data?
    @AppStorage("userName") var userName: String = "ユーザーネーム"
    @AppStorage("isNotificationOn") var isNotificationOn: Bool = false
    
    var image: UIImage? { // UIImage型のプロパティ
        guard let userIconData = userIconData else { return nil }
        return UIImage(data: userIconData)
    }
}
