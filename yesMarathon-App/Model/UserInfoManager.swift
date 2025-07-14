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
    @AppStorage("isNotificationOn") var isNotificationOn: Bool = false
    // YESお題のカテゴリー値
    @AppStorage("yesCategory") var yesCategory: Int = 1 // default value
}
