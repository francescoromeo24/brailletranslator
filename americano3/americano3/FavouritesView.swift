//
//  FavouritesView.swift
//  americano3
//
//  Created by Francesco Romeo on 11/12/24.
//
import SwiftUI
import UIKit

struct FavoritesView: View {
    @Binding var flashcards: [Flashcard]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var starredFlashcards: [Flashcard] {
        flashcards
            .filter { $0.isStarred }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(starredFlashcards, id: \.id) { flashcard in
                        NavigationLink(destination: FlashcardDetailView(flashcard: flashcard)) {
                            VStack {
                                VStack(alignment: .leading) {
                                    Text(flashcard.word.isEmpty ? NSLocalizedString("word", comment: "") : flashcard.word)
                                        .accessibilityLabel(flashcard.word.isEmpty ? 
                                            NSLocalizedString("empty_word", comment: "") : 
                                            String(format: NSLocalizedString("word_label", comment: ""), flashcard.word))
                                        .accessibilityHint(NSLocalizedString("word_flashcard_hint", comment: ""))
                                        .foregroundColor(.gray) // Added gray color for word
                                    Text(flashcard.translation.isEmpty ? NSLocalizedString("translation", comment: "") : flashcard.translation)
                                        .accessibilityLabel(flashcard.translation.isEmpty ? 
                                            NSLocalizedString("empty_translation", comment: "") : 
                                            String(format: NSLocalizedString("translation_label", comment: ""), flashcard.translation))
                                        .accessibilityHint(NSLocalizedString("translation_flashcard_hint", comment: ""))
                                        .foregroundColor(.black) // Added black color for translation
                                }
                                .padding()
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        toggleFlashcardStar(for: flashcard)
                                        triggerHapticFeedback()
                                    }) {
                                        Image(systemName: "star.fill")
                                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                            .foregroundColor(flashcard.isStarred ? .blue : .blue)
                                            .font(.title)
                                            .accessibilityLabel(flashcard.isStarred ?
                                                LocalizedStringKey("unstar_flashcard") :
                                                LocalizedStringKey("star_flashcard"))
                                            .accessibilityHint(LocalizedStringKey("star_button_hint"))
                                    }
                                    .accessibilityAction(.escape) {
                                        toggleFlashcardStar(for: flashcard)
                                    }
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
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(String(format: NSLocalizedString("flashcard_label", comment: ""), flashcard.word, flashcard.translation))
                            .accessibilityHint(LocalizedStringKey("flashcard_details_hint"))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey("favorites"))
            .dynamicTypeSize(..<DynamicTypeSize.large)
            .background(Color("Background"))
        }
    }
    
    func toggleFlashcardStar(for flashcard: Flashcard) {
        guard let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) else { return }
        flashcards[index].isStarred.toggle()
        
        let status = flashcards[index].isStarred ? 
            NSLocalizedString("added_to_favorites", comment: "") : 
            NSLocalizedString("removed_from_favorites", comment: "")
        UIAccessibility.post(notification: .announcement, argument: status)
    }
    
    func triggerHapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
}

#Preview {
    FavoritesView(flashcards: .constant([
        Flashcard(word: "Hello", translation: "Ciao", isStarred: true, dateAdded: Date()),
        Flashcard(word: "World", translation: "Mondo", isStarred: true, dateAdded: Date())
    ]))
}

