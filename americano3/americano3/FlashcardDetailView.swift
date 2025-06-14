//
//  FlashcardDetailView.swift
//  americano3
//
//  Created by Francesco Romeo on 02/01/25.
//
import SwiftUI
import AVFoundation

struct FlashcardDetailView: View {
    let flashcard: Flashcard
    let synthesizer = AVSpeechSynthesizer()
    @AppStorage("selectedLanguage")
    private var selectedLanguage = Locale.current.language.languageCode?.identifier ?? "en"

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                // Testo originale
                Text(flashcard.word.isEmpty ? NSLocalizedString("word", comment: "") : flashcard.word)
                    .accessibilityLabel(flashcard.word.isEmpty ? 
                        NSLocalizedString("empty_word", comment: "") : 
                        String(format: NSLocalizedString("original_word", comment: ""), flashcard.word))
                    .accessibilityHint(NSLocalizedString("original_word_hint", comment: ""))
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .foregroundColor(.gray)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                // Braille translation
                let brailleWords = flashcard.translation.split(separator: " ").map(String.init)
                  
                let originalWords = flashcard.word.split(separator: " ").map(String.init)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(brailleWords.indices, id: \.self) { index in
                        let brailleWord = brailleWords[index]
                        let originalWord = index < originalWords.count ? originalWords[index] : "?"

                        Text(brailleWord)
                            .accessibilityLabel(String(format: NSLocalizedString("braille_word", comment: ""), originalWord))
                            .accessibilityHint(NSLocalizedString("braille_word_hint", comment: ""))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)                   .font(.custom("Courier", size: 20))
                            .tracking(5)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                            .accessibilityLabel(originalWord) 
                            .accessibilityHint(LocalizedStringKey("double_tap_hint"))
                            .onTapGesture {
                                print("Tapped word: \(originalWord)")
                                giveHapticFeedback()
                                speakWord(originalWord)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.vertical)
        }
        .navigationTitle(LocalizedStringKey("details"))
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .accessibilityHint(NSLocalizedString("flashcard_details_hint", comment: ""))
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .background(Color("Background"))
    }

    // Haptic feedback
    // Add this function
    private func speakWord(_ word: String) {
        giveHapticFeedback()
        
        // Get the full language identifier (es-ES instead of just es)
        let languageIdentifier = Locale.current.identifier
        
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = 0.5
        
        // Try exact match first (es-ES), then fallback to language code (es)
        if let voice = AVSpeechSynthesisVoice(language: languageIdentifier) ??
                      AVSpeechSynthesisVoice(language: selectedLanguage) ??
                      AVSpeechSynthesisVoice(language: "en") {
            utterance.voice = voice
        }
        
        synthesizer.speak(utterance)
    }
    
    func giveHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

// Preview
struct FlashcardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardDetailView(flashcard: Flashcard(word: "Hello world", translation: "⠓⠑⠇⠇⠕ ⠺⠕⠗⠇⠙", dateAdded: Date()))
    }
}
