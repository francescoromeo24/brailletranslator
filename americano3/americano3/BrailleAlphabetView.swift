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
    
    @Binding var showGlobalAlert: Bool
    @Binding var alertType: AlphabetType?
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
        
        
        // Uppercase letters
        "A": [true, false, false, false, false, false],
        "B": [true, true, false, false, false, false],
        "C": [true, false, true, false, false, false],
        "D": [true, false, true, true, false, false],
        "E": [true, false, false, true, false, false],
        "F": [true, true, true, false, false, false],
        "G": [true, true, true, true, false, false],
        "H": [true, true, false, true, false, false],
        "I": [false, true, true, false, false, false],
        "J": [false, true, true, true, false, false],
        "K": [true, false, false, false, true, false],
        "L": [true, true, false, false, true, false],
        "M": [true, false, true, false, true, false],
        "N": [true, false, true, true, true, false],
        "O": [true, false, false, true, true, false],
        "P": [true, true, true, false, true, false],
        "Q": [true, true, true, true, true, false],
        "R": [true, true, false, true, true, false],
        "S": [false, true, true, false, true, false],
        "T": [false, true, true, true, true, false],
        "U": [true, false, false, false, true, true],
        "V": [true, true, false, false, true, true],
        "W": [false, true, true, true, false, true],
        "X": [true, false, true, false, true, true],
        "Y": [true, false, true, true, true, true],
        "Z": [true, false, false, true, true, true],
        
        
        
        // Numbers (preceded by numeric prefix ⠼)
        "1": [true, false, false, false, false, false],
        "2": [true, false, true, false, false, false],
        "3": [true, true, false, false, false, false],
        "4": [true, true, true, false, false, false],
        "5": [true, false, false, true, false, false],
        "6": [true, true, true, false, false, false],
        "7": [true, true, true, true, false, false],
        "8": [true, false, true, true, false, false],
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
        
        "à": [true, false, false, false, false, false],
        "è": [true, false, false, true, false, false],
        "é": [false, true, false, true, false, false],
        "ì": [false, true, true, false, false, false],
        "í": [false, true, false, false, true, false],
        "ò": [true, false, false, true, true, false],
        "ó": [true, true, false, false, false, true],
        "ù": [true, false, false, false, true, true],
        "ú": [true, false, true, false, false, true],
        "ä": [true, true, false, false, false, true],
        "ë": [false, true, true, true, false, false],
        "ï": [false, true, true, true, false, false],
        "ö": [true, true, false, false, true, true],
        "ü": [true, true, true, true, false, false],
        "ñ": [true, false, true, true, true, false],
        "ç": [true, false, true, false, false, false], 
        
        "À": [true, false, false, false, false, false],
        "È": [true, false, false, true, false, false],
        "É": [false, true, false, true, false, false],
        "Ì": [false, true, true, false, false, false],
        "Í": [false, true, false, false, true, false],
        "Ò": [true, false, false, true, true, false],
        "Ó": [true, true, false, false, false, true],
        "Ù": [true, false, false, false, true, true],
        "Ú": [true, false, true, false, false, true],
        "Ä": [true, true, false, false, false, true],
        "Ë": [false, true, true, true, false, false],
        "Ï": [false, true, true, true, false, false],
        "Ö": [true, true, false, false, true, true],
        "Ü": [true, true, true, true, false, false],
        "Ñ": [true, false, true, true, true, false],
        "Ç": [true, false, true, false, false, false],
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
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if selectedType == .uppercase || selectedType == .numbers {
                            Button(action: {
                                alertType = selectedType
                                showGlobalAlert = true
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 16)
                            .accessibilityLabel(LocalizedStringKey("uppercase_info_accessibility"))
                        }
                    }
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
            BrailleAlphabetView(showGlobalAlert: .constant(false), alertType: .constant(nil))
        
        }
  

