//
//  HomeView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct HomeView: View {
    let costCards = [
        CostCardDM(icon: "google", platform: "TikTok", amount: 12),
        CostCardDM(icon: "google", platform: "Github", amount: 24),
        CostCardDM(icon: "google", platform: "Dropbox", amount: 15),
        CostCardDM(icon: "google", platform: "TikTok", amount: 12),
        CostCardDM(icon: "google", platform: "Github", amount: 24),
        CostCardDM(icon: "google", platform: "Dropbox", amount: 15)
    ]
    
    let colors: [Color] = [Color.customPurpleColor, Color.customGreenColor, Color.customYellowColor]
    
    var totalAmount: Double { costCards.reduce(0) { $0 + $1.amount } }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                cardView
            }
            .background(Color.customBlueColor)
            .safeAreaPadding(.bottom, 60)
        }
    }
    
    @ViewBuilder
    var cardView: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Saving")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    Text("...")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Color.customBlueColor
                                .opacity(0.7)
                                .overlay(Color.white.opacity(0.3))
                        )
                        .clipShape(Capsule())
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ZStack {
                            Capsule()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(.white)
                                .frame(width: 90)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        ForEach(Array(costCards.enumerated()), id: \.element.platform) { index, card in
                            let percentage = (card.amount / totalAmount) * 100
                            let delay = 0.1 * Double(index)
                            CostCardView(
                                icon: card.icon,
                                platform: card.platform,
                                amount: card.amount,
                                percentage: Int(percentage),
                                delay: delay,
                                geometryWidth: geometry.size.width,
                                backgroundColor: colors[index % colors.count]
                            )
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 10)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
    }
}

#Preview {
    HomeView()
}
