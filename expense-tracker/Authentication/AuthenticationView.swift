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
        viewModel.isLoading = true
        print("Loading started:", viewModel.isLoading)
        
        Task {
            await viewModel.signInWithGoogle()
            viewModel.isLoading = false
            print("Loading finished:", viewModel.isLoading)
        }
    }
    
    var body: some View {
        ZStack {
            Color.customGreyColor.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(Color.customBlueColor)
                        .frame(height: UIScreen.main.bounds.height * 0.55)
                        .frame(width: UIScreen.main.bounds.width)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Save")
                                .font(.system(size: 70, weight: .bold))
                                .foregroundColor(.white)
                            + Text("Smart")
                                .font(.system(size: 70, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 15)
                        
                        Text("Empowering You with Smart Saving")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                        
                        Text("Strategies, Budgeting Insights,")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .padding(.top, 1)
                            .padding(.leading, 15)
                            .padding(.bottom, 50)
                        
                        Button(action:{
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            signInWithGoogle()
                        }) {
                            HStack(spacing: 10) {
                                Image("google")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign in with Google")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 80)
                            .background(Color.init(hex: "bc9cfa"))
                            .cornerRadius(50)
                            .padding(.horizontal, 16)
                            
                        }
                    }
                    .padding(.bottom, 50)
                    
                    LottieView(loopMode: .loop, animationName: "authAnimate")
                        .scaleEffect(0.35)
                        .offset(y: -70)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 150)
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                LottieView(loopMode: .loop, animationName: "progressAnimation")
                    .scaleEffect(0.1)
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
