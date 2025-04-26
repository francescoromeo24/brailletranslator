import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: NSLocalizedString("welcome_title", comment: ""),
            description: NSLocalizedString("welcome_description", comment: ""),
            imageName: "Onboarding1"
        ),
        OnboardingPage(
            title: NSLocalizedString("create_wordlist_title", comment: ""),
            description: NSLocalizedString("create_wordlist_description", comment: ""),
            imageName: "Onboarding2"
        ),
        OnboardingPage(
            title: NSLocalizedString("braille_title", comment: ""),
            description: NSLocalizedString("braille_description", comment: ""),
            imageName: "Onboarding3"
        )
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    hasCompletedOnboarding = true
                }
            }) {
                Text(currentPage == pages.count - 1 ? 
                     NSLocalizedString("get_started", comment: "") : 
                     NSLocalizedString("next", comment: ""))
                    .padding()
                    .frame(width:200, height:50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .padding(.vertical)
            
            HStack(spacing: 10) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? .blue : .gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.bottom)
        }
        .background(Color("Background").ignoresSafeArea())  
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
