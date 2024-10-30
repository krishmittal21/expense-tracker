//
//  ERUser.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import Foundation

struct ERUserModelName {
    static let id = "id"
    static let name = "name"
    static let userType = "userType"
    static let email = "email"
    static let phoneNumber = "phoneNumber"
    static let address = "address"
    static let joined = "joined"
    static let firestore = "users"
}

struct ERUser: Codable, Hashable, Identifiable {
    let id: String
    let name: String?
    let email: String?
    let userType: String?
    let phoneNumber: String?
    let address: String?
    let joined: TimeInterval
}
