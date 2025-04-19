import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: NSLocalizedString("welcome_title", comment: ""),
            description: NSLocalizedString("welcome_description", comment: ""),
            imageName: "textformat.abc"
        ),
        OnboardingPage(
            title: NSLocalizedString("translation_title", comment: ""),
            description: NSLocalizedString("translation_description", comment: ""),
            imageName: "arrow.left.arrow.right"
        ),
        OnboardingPage(
            title: NSLocalizedString("braille_title", comment: ""),
            description: NSLocalizedString("braille_description", comment: ""),
            imageName: "brazilianrealsign"
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
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
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
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
