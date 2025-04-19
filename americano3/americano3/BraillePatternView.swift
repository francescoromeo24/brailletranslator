import SwiftUI
import AVFoundation

struct BraillePatternView: View {
    let synthesizer = AVSpeechSynthesizer()
    let pattern: [Bool]
    let label: String
    @State private var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private func speakLetter(_ letter: String) {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguages = ["en", "it", "es", "fr", "de", "pt-PT", "pt-BR"]
        let languageToUse = supportedLanguages.contains(deviceLanguage) ? deviceLanguage : "en"
        
        let characterToSpeak: String
        switch letter {
        case "?": characterToSpeak = NSLocalizedString("question_mark", comment: "")
        case "!": characterToSpeak = NSLocalizedString("exclamation_mark", comment: "")
        case ".": characterToSpeak = NSLocalizedString("period", comment: "")
        case ",": characterToSpeak = NSLocalizedString("comma", comment: "")
        case ";": characterToSpeak = NSLocalizedString("semicolon", comment: "")
        case ":": characterToSpeak = NSLocalizedString("colon", comment: "")
        case "(": characterToSpeak = NSLocalizedString("open_parenthesis", comment: "")
        case ")": characterToSpeak = NSLocalizedString("close_parenthesis", comment: "")
        case "\"": characterToSpeak = NSLocalizedString("quotation_mark", comment: "")
        case "'": characterToSpeak = NSLocalizedString("apostrophe", comment: "")
        default: characterToSpeak = letter
        }
        
        let utterance = AVSpeechUtterance(string: characterToSpeak)
        if let voice = AVSpeechSynthesisVoice(language: languageToUse) {
            utterance.voice = voice
        } else if let defaultVoice = AVSpeechSynthesisVoice(language: "en") {
            utterance.voice = defaultVoice
        }
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(15)), count: 2), spacing: 5) {
            ForEach(0..<min(6, pattern.count), id: \.self) { index in
                Circle()
                    .frame(width: min(15, UIFontMetrics.default.scaledValue(for: 15)),
                           height: min(15, UIFontMetrics.default.scaledValue(for: 15)))
                    .foregroundColor(pattern.indices.contains(index) ? (pattern[index] ? .primary : Color.secondary.opacity(0.3)) : .clear)
            }
        }
        .frame(width: 50, height: 60)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .onTapGesture {
            speakLetter(label)
        }
    }
}

#Preview {
    BraillePatternView(
        pattern: [true, false, false, false, false, false],
        label: "A"
    )
}