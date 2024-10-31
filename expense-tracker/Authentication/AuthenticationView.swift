//
//  AuthenticationView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var viewModel = AuthenticationViewModel()
    @State var showLogin = false
    @State private var activeTab: Tab = .home
    @State private var isTabbarHidden: Bool = false
    
    private func signInWithGoogle() {
        Task {
            await viewModel.signInWithGoogle()
        }
    }
    
    @ViewBuilder
    private func displayContentView() -> some View {
        if UserDefaults.standard.bool(forKey: K.isLoggedIn)  {
            TabBarContainerView(activeTab: $activeTab, isTabbarHidden: $isTabbarHidden)
        } else {
            AuthenticationView()
        }
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                VStack(spacing: 10) {
                    SignInWithAppleButton(.continue) { request in
                        viewModel.handleSignInWithAppleRequest(request)
                    } onCompletion: { result in
                        viewModel.handleSignInWithAppleCompletion(result)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .cornerRadius(20)
                    .signInWithAppleButtonStyle(.white)
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    AuthenticationButton(label: "Continue with Google", iconImage: Image("google")) { signInWithGoogle() }
                                        
                }
                .padding(.top, 150)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AuthenticationView()
}
