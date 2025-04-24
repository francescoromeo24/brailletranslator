//
//  FlashcardView.swift
//  americano3
//
//  Created by Francesco Romeo on 15/12/24.
//
import SwiftUI
import UIKit

struct FlashcardView: View {
    @Binding var flashcard: Flashcard
    var onToggleStar: (Flashcard) -> Void
    @State private var navigateToDetail = false

    var body: some View {
        VStack {
            // Flashcard content (click to see details)
            VStack(alignment: .leading) {
                Text(flashcard.word.isEmpty ? NSLocalizedString("word", comment: "") : flashcard.word)
                    .accessibilityLabel(flashcard.word.isEmpty ? 
                        NSLocalizedString("empty_word", comment: "") : 
                        String(format: NSLocalizedString("word_label", comment: ""), flashcard.word))
                    .accessibilityHint(NSLocalizedString("word_flashcard_hint", comment: ""))
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text(flashcard.translation.isEmpty ? NSLocalizedString("translation", comment: "") : flashcard.translation)
                    .accessibilityLabel(flashcard.translation.isEmpty ? 
                        NSLocalizedString("empty_translation", comment: "") : 
                        String(format: NSLocalizedString("translation_label", comment: ""), flashcard.translation))
                    .accessibilityHint(NSLocalizedString("translation_flashcard_hint", comment: ""))
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .font(.custom("Courier", size: 20))
                    .tracking(5)
                    .foregroundColor(.black)
                    .padding(.top, 2)
            }
            .padding()
            .onTapGesture {
                navigateToDetail = true
                provideHapticFeedback()
                UIAccessibility.post(notification: .announcement, argument: "Opening details for \(flashcard.word)")
            }
            .accessibilityHint("Double tap to view details")

            // Star button to mark as favorite
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        flashcard.isStarred.toggle()
                    }
                    onToggleStar(flashcard)
                    provideHapticFeedback()
                    announceStarStatus()
                }) {
                    Image(systemName: flashcard.isStarred ? "star.fill" : "star")
                        .renderingMode(.template)
                        .foregroundColor(.blue)
                        .font(.title)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        .accessibilityLabel(flashcard.isStarred ? 
                            NSLocalizedString("unstar_flashcard", comment: "") : 
                            NSLocalizedString("star_flashcard", comment: ""))
                        .accessibilityHint(NSLocalizedString("star_button_hint", comment: ""))
                }
                .padding()
            }
        }
        .frame(
            width: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 146,
            height: UIDevice.current.userInterfaceIdiom == .pad ? 220 : 164
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .stroke(Color.blue, lineWidth: 1)
                .shadow(radius: 2)
        )
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .navigationDestination(isPresented: $navigateToDetail) {
            FlashcardDetailView(flashcard: flashcard)
        }
    }

    // Haptic feedback
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    // Accessibility announcement for favorites toggle
    private func announceStarStatus() {
        let status = flashcard.isStarred ? 
            NSLocalizedString("added_to_favorites", comment: "") : 
            NSLocalizedString("removed_from_favorites", comment: "")
        UIAccessibility.post(notification: .announcement, argument: status)
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(
            flashcard: .constant(Flashcard(word: "Hello", translation: "⠉ ⠊ ⠁ ⠕", isStarred: false, dateAdded: Date())),
            onToggleStar: { flashcard in
                print("Toggled star for flashcard with word: \(flashcard.word)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
