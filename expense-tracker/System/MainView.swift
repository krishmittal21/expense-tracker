//
//  ContentView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct MainView: View {
    @State private var activeTab: Tab = .home
    @State private var isTabbarHidden: Bool = false

    var body: some View {
        TabBarContainerView(activeTab: $activeTab, isTabbarHidden: $isTabbarHidden)
    }
}

#Preview {
    MainView()
}
