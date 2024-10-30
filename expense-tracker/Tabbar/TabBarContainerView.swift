//
//  TabBarContainerView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct TabBarContainerView: View {
    @Binding var activeTab: Tab
    @Binding var isTabbarHidden: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        SwiftUI.Tab.init(value: .home) {
                            HomeView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        SwiftUI.Tab.init(value: .settings) {
                            Text("Settings")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        HomeView()
                            .tag(Tab.home)
                            .background {
                                if !isTabbarHidden {
                                    HideTabBar {
                                        isTabbarHidden = true
                                    }
                                }
                            }
                        
                        Text("Settings")
                            .tag(Tab.settings)
                    }
                }
            }
            
            CustomTabBar(activeTab: $activeTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
