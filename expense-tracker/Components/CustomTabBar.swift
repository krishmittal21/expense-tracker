//
//  CustomTabBar.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct CustomTabBar: View {
    var activeForeground: Color = .green
    var activeBackground: Color = .black
    @Binding var activeTab: Tab
    @Namespace private var animation
    @State private var tabLocation: CGRect = .zero
    @State private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        let status = activeTab == .home || activeTab == .settings
//        let status = activeTab == .home

        HStack(spacing: !status ? 0 : 12) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 45, height: 45)
                            
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(activeTab == tab ? activeForeground : .gray)
                        .padding(.vertical, 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 20)
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(.clear)
                                    .onGeometryChange(for: CGRect.self, of: {
                                        $0.frame(in: .named("TABBARVIEW"))
                                    }, action: { newValue in
                                        tabLocation = newValue
                                    })
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 10)
            .frame(height: 60)
            .background(
                .background
                    .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)),
                in: .capsule
            )
            .zIndex(10)

            Button {
                if activeTab == .home {
                    print("Profile")
                } else {
                    viewModel.signOut()
                }
            } label: {
                MorphingSymbolView(
                    symbol: activeTab == .home ? "plus" : "slider.vertical.3",
                    config: .init(
                        font: .title,
                        frame: .init(width: 57, height: 57),
                        radius: 2,
                        foregroundColor: activeForeground,
                        keyFrameDuration: 0.3,
                        symbolAnimation: .smooth(duration: 0.3, extraBounce: 0)
                    )
                )
                .background(activeBackground.gradient)
                .clipShape(.circle)
            }
            .allowsHitTesting(status)
            .offset(x: status ? 0 : -20)
            .padding(.leading, status ? 0 : -42)
        }
        .padding(.bottom, 10)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}
