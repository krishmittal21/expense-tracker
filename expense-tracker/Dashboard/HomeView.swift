//
//  HomeView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(1...50, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.background)
                            .frame(height: 50)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Track")
            .background(Color.primary.opacity(0.2))
            .safeAreaPadding(.bottom, 60)
        }
    }
}
