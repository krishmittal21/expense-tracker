//
//  LottieView.swift
//  expense-tracker
//
//  Created by Krish Mittal on 31/10/24.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let loopMode: LottieLoopMode
    let animationName: String

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}
