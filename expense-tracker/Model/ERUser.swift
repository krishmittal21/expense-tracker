//
//  ERUser.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import Foundation

struct ERUserModelName {
    static let address = "address"
    static let dateCreated = "dateCreated"
    static let dateEdited = "dateEdited"
    static let email = "email"
    static let firestore = "users"
    static let id = "id"
    static let joined = "joined"
    static let name = "name"
    static let phoneNumber = "phoneNumber"
    static let userType = "userType"
}

struct ERUser: Codable, Hashable, Identifiable {
    let address: String?
    var dateCreated: String?
    var dateEdited: String?
    let email: String?
    let id: String
    let name: String?
    let phoneNumber: String?
    let userType: String?
}
