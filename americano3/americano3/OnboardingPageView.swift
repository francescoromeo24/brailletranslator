//
//  OnboardingPageView.swift
//  americano3
//
//  Created by Francesco Romeo on 19/04/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}


#Preview {
    OnboardingPageView(page: OnboardingPage(
        title: "Welcome",
        description: "This is a sample onboarding page",
        imageName: "textformat.abc"
    ))
}
