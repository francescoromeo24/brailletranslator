//
//  americano3App.swift
//  americano3
//
//  Created by Francesco Romeo on 10/12/24.
//

import SwiftUI

@main
struct Americano3App: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContainerView()
            } else {
                OnboardingView()
            }
        }
    }
}
