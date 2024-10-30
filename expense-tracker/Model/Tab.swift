//
//  Tab.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case settings = "gearshape"
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .settings:
            "Settings"
        }
    }
}
