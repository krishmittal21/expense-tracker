//
//  Constants.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import Foundation

struct K {
    static let isLoggedIn = "isLoggedIn"
    static let isSigningUp = "isSigningUp"
    static let isAppFirstStart = "isAppFirstStart"
    static let userData = "userData"
}

extension Notification.Name {
    static let updateProfile = Notification.Name("updateProfile")
}

