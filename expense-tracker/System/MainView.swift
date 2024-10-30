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
    @State private var viewModel = Authentication()

    var body: some View {
        displayContentView()
    }
    
    @ViewBuilder
    private func displayContentView() -> some View {
        if UserDefaults.standard.bool(forKey: K.isLoggedIn) || !viewModel.currentUserId.isEmpty {
            TabBarContainerView(activeTab: $activeTab, isTabbarHidden: $isTabbarHidden)
        } else {
            AuthenticationView()
        }
    }
}

#Preview {
    MainView()
}
