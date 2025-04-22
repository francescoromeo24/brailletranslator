//
//  OnboardingPageView.swift
//  americano3
//
//  Created by Francesco Romeo on 19/04/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.horizontal)
            
            Image(systemName: page.imageName)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .ignoresSafeArea()
    }
}


#Preview {
    OnboardingPageView(page: OnboardingPage(
        title: "Welcome",
        description: "This is a sample onboarding page",
        imageName: "textformat.abc"
    ))
}
