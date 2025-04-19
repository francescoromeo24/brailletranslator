//
//  BrailleAlphabetView.swift
//  americano3
//
//  Created by Francesco Romeo on 28/01/25.
//
import SwiftUI
import AVFoundation

struct BrailleAlphabetView: View {
    
    // Enum to define the different types of alphabets
    enum AlphabetType: String, CaseIterable {
        case lowercase
        case uppercase
        case numbers
        case specialChars
        
        var localized: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.lowercased())
            }
    }
    
    @State private var selectedType: AlphabetType = .lowercase

    // Braille dictionary mapping characters to their respective Braille patterns
    let brailleDictionary: [Character: [Bool]] = [
        // Lowercase letters
        "a": [true, false, false, false, false, false],
        "b": [true, true, false, false, false, false],
        "c": [true, false, true, false, false, false],
        "d": [true, false, true, true, false, false],
        "e": [true, false, false, true, false, false],
        "f": [true, true, true, false, false, false],
        "g": [true, true, true, true, false, false],
        "h": [true, true, false, true, false, false],
        "i": [false, true, true, false, false, false],
        "j": [false, true, true, true, false, false],
        "k": [true, false, false, false, true, false],
        "l": [true, true, false, false, true, false],
        "m": [true, false, true, false, true, false],
        "n": [true, false, true, true, true, false],
        "o": [true, false, false, true, true, false],
        "p": [true, true, true, false, true, false],
        "q": [true, true, true, true, true, false],
        "r": [true, true, false, true, true, false],
        "s": [false, true, true, false, true, false],
        "t": [false, true, true, true, true, false],
        "u": [true, false, false, false, true, true],
        "v": [true, true, false, false, true, true],
        "w": [false, true, true, true, false, true],
        "x": [true, false, true, false, true, true],
        "y": [true, false, true, true, true, true],
        "z": [true, false, false, true, true, true],
        
        // Uppercase letters (prefixed with ⠠)
        "A": [true, false, false, false, false, true],
        "B": [true, true, false, false, false, true],
        "C": [true, false, true, false, false, true],
        "D": [true, false, true, true, false, true],
        "E": [true, false, false, true, false, true],
        "F": [true, true, true, false, false, true],
        "G": [true, true, true, true, false, true],
        "H": [true, true, false, true, false, true],
        "I": [false, true, true, false, false, true],
        "J": [false, true, true, true, false, true],
        "K": [true, false, false, false, true, true],
        "L": [true, true, false, false, true, true],
        "M": [true, false, true, false, true, true],
        "N": [true, false, true, true, true, true],
        "O": [true, false, false, true, true, true],
        "P": [true, true, true, false, true, true],
        "Q": [true, true, true, true, true, true],
        "R": [true, true, false, true, true, true],
        "S": [false, true, true, false, true, true],
        "T": [false, true, true, true, true, true],
        "U": [true, false, false, false, true, true],
        "V": [true, true, false, false, true, true],
        "W": [false, true, true, true, false, true],
        "X": [true, false, true, false, true, true],
        "Y": [true, false, true, true, true, true],
        "Z": [true, false, false, true, true, true],
        
        // Numbers (preceded by numeric prefix ⠼)
        "1": [true, false, false, false, false, false],
        "2": [true, true, false, false, false, false],
        "3": [true, false, true, false, false, false],
        "4": [true, false, true, true, false, false],
        "5": [true, false, false, true, false, false],
        "6": [true, true, true, false, false, false],
        "7": [true, true, true, true, false, false],
        "8": [true, true, false, true, false, false],
        "9": [false, true, true, false, false, false],
        "0": [false, true, true, true, false, false],

        // Punctuation
            ".": [true, false, false, true, true, false], // Period
            ",": [true, false, false, false, false, false], // Comma
            ";": [true, false, false, false, true, false], // Semicolon
            ":": [true, false, true, false, true, false], // Colon
            "?": [false, true, false, true, false, false], // Question mark
            "!": [false, true, true, false, false, false], // Exclamation mark
            "(": [false, false, true, true, false, false], // Open parenthesis
            ")": [false, false, false, true, false, true], // Close parenthesis
            "\"": [true, false, false, true, false, true], // Quotation marks
            "'": [true, true, false, false, true, false], // Apostrophe

        // Special symbols
            "+": [true, true, true, true, false, false], // Addition
            "-": [true, true, false, false, true, true], // Subtraction
            "*": [true, false, false, false, true, true], // Multiplication
            "/": [false, true, true, false, true, false], // Division
            "=": [true, false, false, false, true, true], // Equals
            "@": [false, true, false, true, false, true], // At symbol
            "#": [true, false, true, false, true, true], // Number sign
            "&": [false, true, true, false, true, false], // Ampersand
            "%": [false, true, false, true, true, false], // Percent
            "$": [true, true, false, true, false, true], // Dollar
            "€": [false, false, true, false, true, true], // Euro

        // Accented letters
        "à": [true, false, false, false, false, false, true, true], // a with grave
        "è": [true, false, false, true, false, false, true, true], // e with grave
        "é": [true, false, false, true, false, false, true, false], // e with acute
        "ì": [false, true, true, false, false, false, true, true], // i with grave
        "í": [false, true, true, false, false, false, true, false], // i with acute
        "ò": [true, false, false, true, true, false, true, true], // o with grave
        "ó": [true, false, false, true, true, false, true, false], // o with acute
        "ù": [true, false, false, false, true, true, true, true], // u with grave
        "ú": [true, false, false, false, true, true, true, false], // u with acute
        "ä": [true, false, false, false, false, false, false, true], // a with umlaut
        "ë": [true, false, false, true, false, false, false, true], // e with umlaut
        "ï": [false, true, true, false, false, false, false, true], // i with umlaut
        "ö": [true, false, false, true, true, false, false, true], // o with umlaut
        "ü": [true, false, false, false, true, true, false, true], // u with umlaut
        "ñ": [true, false, true, true, true, false, true, false], // n with tilde
        "ç": [true, false, true, false, false, false, true, false], // c with cedilla

        // Uppercase accented letters
        "À": [true, false, false, false, false, false, true, true],
        "È": [true, false, false, true, false, false, true, true],
        "É": [true, false, false, true, false, false, true, false],
        "Ì": [false, true, true, false, false, false, true, true],
        "Í": [false, true, true, false, false, false, true, false],
        "Ò": [true, false, false, true, true, false, true, true],
        "Ó": [true, false, false, true, true, false, true, false],
        "Ù": [true, false, false, false, true, true, true, true],
        "Ú": [true, false, false, false, true, true, true, false],
        "Ä": [true, false, false, false, false, false, false, true],
        "Ë": [true, false, false, true, false, false, false, true],
        "Ï": [false, true, true, false, false, false, false, true],
        "Ö": [true, false, false, true, true, false, false, true],
        "Ü": [true, false, false, false, true, true, false, true],
        "Ñ": [true, false, true, true, true, false, true, false],
        "Ç": [true, false, true, false, false, false, true, false],

    ]
    
    

    // Function to filter and sort the alphabet based on the selected type
    func filteredAlphabet() -> [(label: String, pattern: [Bool])] {
        switch selectedType {
        case .lowercase:
            return brailleDictionary.keys
                .filter { $0.isLowercase && !$0.isNumber && !(",.?!;:()\"'".contains($0)) }
                .sorted()
                .map { (String($0), brailleDictionary[$0]!) }
        case .uppercase:
            return brailleDictionary.keys
                .filter { $0.isUppercase && !$0.isNumber && !(",.?!;:()\"'".contains($0)) }
                .sorted()
                .map { (String($0), brailleDictionary[$0]!) }
        case .numbers:
            return brailleDictionary.keys
                .filter { $0.isNumber }
                .sorted()
                .map { (String($0), brailleDictionary[$0]!) }
        case .specialChars:
            // Separating punctuation from other special symbols
            let punctuation: [(String, [Bool])] = brailleDictionary.keys
                .filter { ",.?!;:()\"'".contains($0) }
                .sorted()
                .map { (String($0), brailleDictionary[$0]!) }
            
            let specialSymbols: [(String, [Bool])] = brailleDictionary.keys
                .filter { !",.?!;:()\"'".contains($0) && !$0.isLetter && !$0.isNumber }
                .sorted()
                .map { (String($0), brailleDictionary[$0]!) }

            return punctuation + specialSymbols
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Picker to select the alphabet type
                    Picker("Select Alphabet Type", selection: $selectedType) {
                        ForEach(AlphabetType.allCases, id: \.self) { type in
                            Text(type.localized)
                                .accessibilityLabel(LocalizedStringKey(type.rawValue))
                                .accessibilityHint(LocalizedStringKey("double_tap_to_switch_to_braille_alphabet"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .font(.body)
                                .lineLimit(2)
                                .minimumScaleFactor(0.6)
                                .multilineTextAlignment(.center)
                        }
                       
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(LocalizedStringKey("braille_alphabet_tab"))
                    .accessibilityHint(LocalizedStringKey("double_tap_to_switch_to_braille_alphabet"))

                    // Displaying the filtered and sorted Braille alphabet
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 30) {
                        ForEach(filteredAlphabet(), id: \.label) { item in
                            VStack(spacing: 10) {
                                Text(item.label)
                                    .accessibilityLabel(LocalizedStringKey("braille_pattern_for \(item.label)"))
                                    .accessibilityHint(LocalizedStringKey("double_tap_to_hear_character"))
                                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.gray)
                                    .accessibilityLabel(item.label)
                                
                                BraillePatternView(pattern: item.pattern, label: item.label)
                                    .accessibilityLabel(LocalizedStringKey("braille_pattern_for \(item.label)"))
                                    .accessibilityHint(LocalizedStringKey("double_tap_to_hear_character"))
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                    .padding()
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(LocalizedStringKey("braille_alphabet"))
                }
            }
            .background(Color("Background"))
            .navigationTitle(LocalizedStringKey("braille_alphabet"))
            .accessibilityLabel(LocalizedStringKey("braille_alphabet"))
            .accessibilityHint(LocalizedStringKey("braille_alphabet_tab"))
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .foregroundColor(.blue)
        }
    }
}
        #Preview {
            BrailleAlphabetView()
        
        }
  
