//
//  DashboardView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI

struct DashboardView: View {
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
                header
                
                cardView
            }
            .ignoresSafeArea()
            .background(Color.customBlueColor)
            .safeAreaPadding(.bottom, 60)
        }
    }
    
    @ViewBuilder
    var header: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color.customGreyColor)
                .frame(height: UIScreen.main.bounds.height * 0.40)
                .frame(width: UIScreen.main.bounds.width)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack() {
                    VStack(alignment: .leading, spacing: 5) {
                            Text("Krish Mittal")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading, 15)
                        Text("Welcome Back")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color.customGreyColor)
                            .frame(width: 50, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.customBlueColor.opacity(0.5), lineWidth: 1)
                            )
                        
                        Image("menuDots")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.customBlueColor)
                    }
                    .padding(.trailing, 15)
                }
                .padding(.top, 60)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Balance")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                    
                    Text("$\(String(format: "%.2f", totalAmount))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 15)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Income")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                        Text("$34333344")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                    }
                    .padding(.leading, 50)
                    
                    Spacer()
                    
                    Text("|")
                        .font(.system(size: 50, weight: .ultraLight))
                        .foregroundColor(.black.opacity(0.6))
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Spendings")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                        Text("-$34333389")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                    }
                    .padding(.trailing, 50)
                }
                .frame(maxWidth: .infinity)
                .frame(width: UIScreen.main.bounds.width - 32, height: 80)
                .background(Color.customYellowColor)
                .cornerRadius(50)
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    var cardView: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Saving")
                        .font(.system(size: 32, weight: .medium))
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
    DashboardView()
}
