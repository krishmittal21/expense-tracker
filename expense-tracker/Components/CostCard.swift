//
//  CostCard.swift
//  expense-tracker
//
//  Created by Krish Mittal on 01/11/24.
//

import SwiftUI

struct CostCard: View {
    let icon: String
    let platform: String
    let amount: Double
    let percentage: Int
    let backgroundColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(
                        backgroundColor
                            .opacity(0.7)
                            .overlay(Color.white.opacity(0.3))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(platform)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            
            Text(String(format: "$%.2f", amount))
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(.white)
            
            Text("\(percentage)%")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 24)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    backgroundColor
                        .opacity(0.7)
                        .overlay(Color.white.opacity(0.3))
                )
                .clipShape(Capsule())
        }
        .padding(16)
        .padding(.vertical, 8)
        .frame(width: 160, alignment: .leading)
        .background(backgroundColor.opacity(0.8))
        .cornerRadius(20)
    }
}

struct CostCardView: View {
    let icon: String
    let platform: String
    let amount: Double
    let percentage: Int
    let delay: Double
    let geometryWidth: CGFloat
    let backgroundColor: Color

    @State private var isVisible = false

    var body: some View {
        CostCard(icon: icon, platform: platform, amount: amount, percentage: percentage, backgroundColor: backgroundColor)
            .offset(x: isVisible ? 0 : geometryWidth)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

#Preview {
    CostCardView(icon: "google", platform: "TikTok", amount: 12, percentage: 50, delay: 0.1, geometryWidth: 300, backgroundColor: .red)
}
