//
//  AuthenticationButton.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//


import SwiftUI

struct AuthenticationButton: View {
    @Environment(\.colorScheme) var colorScheme
    var label: String
    var iconName: String?
    var iconImage: Image?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let iconImage = iconImage {
                    iconImage
                        .resizable()
                        .frame(width: 15, height: 15)
                } else if let iconName = iconName {
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 15, height: 10)
                        .foregroundStyle(.blue)
                }
                
                Text(label)
                    .bold()
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
