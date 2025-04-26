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
        VStack {
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: 350, minHeight: 300)
            
            
            if page.imageName == "Onboarding1" || page.imageName == "Onboarding3" {
                let imageAsset = "\(page.imageName)\(colorScheme == .dark ? "Dark" : "Light")"
                Image(imageAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding(.bottom,40)
            } else {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding(.bottom,40)
            }
            
            Spacer(minLength: 50)
        }
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
