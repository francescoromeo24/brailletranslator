//
//  ContentView.swift
//  americano3
//
//  Created by Francesco Romeo on 10/12/24.
//

import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = ContentViewFunc()
    @Environment(\.colorScheme) var colorScheme
    @State private var showSettings = false
   
    
    // Replace with this at the top of your ContentView struct:
    @State private var synthesizer = AVSpeechSynthesizer()
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @State private var isBrailleKeyboardActive = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    }
    
    private func speakTranslation() {
        let textToSpeak = viewModel.isTextToBraille ? viewModel.brailleOutput : viewModel.textInput
        guard !textToSpeak.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        if let voice = AVSpeechSynthesisVoice(language: selectedLanguage) {
            utterance.voice = voice
        }
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
  
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 5) {
                    Spacer()
                        .frame(height: 10)
                    
                    // Text Input Section
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(viewModel.isTextToBraille ? LocalizedStringKey("text_label") : LocalizedStringKey("braille_label"))
                                .accessibilityLabel(viewModel.isTextToBraille ? LocalizedStringKey("text_label") : LocalizedStringKey("braille_label"))
                                .accessibilityHint(LocalizedStringKey("enter_text_hint"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .gray)
                                
                            
                            Spacer()
                            
                        }
                        
                        TextField(LocalizedStringKey(viewModel.placeholderText()), text: $viewModel.textInput, axis: .vertical)
                            .accessibilityLabel(LocalizedStringKey("text_label"))
                            .accessibilityHint(LocalizedStringKey("enter_text_hint"))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .padding()
                            .frame(minHeight: 80)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                            .foregroundColor(.gray)
                            .accessibilityHint(LocalizedStringKey("enter_text_hint"))
                            .onChange(of: viewModel.textInput) {
                                viewModel.updateTranslation()
                            }
                            .padding(5)
                    }
                    
                    // Button Row: Switch Translation Mode & Add Flashcard
                    HStack {
                        // Button to swap translation direction
                        Button(action: {
                            viewModel.swapTranslation()
                        }) {
                            Image(systemName: "arrow.trianglehead.swap")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .padding()
                                .background(Circle().stroke(Color.blue, lineWidth: 2))
                        }
                        .accessibilityLabel(NSLocalizedString("swap_button_label", comment: ""))
                        .accessibilityHint(NSLocalizedString("swap_button_hint", comment: ""))
                        
                        Spacer()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 60:20)
                        
                        // Button to add a flashcard
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            viewModel.addFlashcard()
                        }) {
                            Image(systemName: "plus")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .padding()
                                .background(Circle().stroke(Color.blue, lineWidth: 2))
                        }
                        .accessibilityLabel(NSLocalizedString("add_flashcard_label", comment: ""))
                        .accessibilityHint(NSLocalizedString("add_flashcard_hint", comment: ""))
                    }
                    .padding(.top, 5.0)
                    
                    // Braille Output Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text(viewModel.isTextToBraille ? LocalizedStringKey("braille_label") : LocalizedStringKey("text_label"))
                            .accessibilityLabel(viewModel.isTextToBraille ? LocalizedStringKey("braille_label") : LocalizedStringKey("text_label"))
                            .accessibilityHint(LocalizedStringKey("swipe_to_hear"))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                            .padding([.top, .leading], 10.0)
                            
                        
                        // Display the translated Braille output
                        ScrollView(.vertical, showsIndicators: true) {
                            TextField(viewModel.isTextToBraille ? LocalizedStringKey("output_braille_placeholder") : LocalizedStringKey("output_text_placeholder"), 
                                     text: $viewModel.brailleOutput, 
                                     axis: .vertical)
                                .accessibilityLabel(LocalizedStringKey("translation"))
                                .accessibilityHint(viewModel.isTextToBraille ?
                                    LocalizedStringKey("tap_to_hear_braille_translation") : 
                                    LocalizedStringKey("tap_to_hear_text_translation"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .font(.custom("Courier", size: 20))
                                .tracking(5)
                                .padding()
                                .frame(minHeight: 80)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                                .disabled(true)
                                .accessibilityLabel(viewModel.textInput.map { String($0) }.joined(separator: ", "))
                                .accessibilityHint(LocalizedStringKey("swipe_to_hear"))
                                .onTapGesture {
                                    viewModel.speakTranslation(with: synthesizer, in: selectedLanguage)
                                }
                        }
                        .padding(5)
                        .frame(minHeight: 80)
                    }
                    
                    // Importer and Camera Buttons
                    HStack {
                        // Import text or image for translation
                        Importer(selectedText: $viewModel.selectedText, selectedImage: $viewModel.selectedImage, translatedBraille: $viewModel.translatedBraille)
                        
                        Spacer()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 60:20)
                            
                        
                        // Open the camera to capture text
                        Button(action: {
                            viewModel.isCameraPresented = true
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 25))
                                .accessibilityLabel(LocalizedStringKey("camera_button_label"))
                                .accessibilityHint(LocalizedStringKey("camera_button_hint"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Circle().stroke(Color.blue, lineWidth: 2))
                        }
                        
                        .fullScreenCover(isPresented: $viewModel.isCameraPresented) {
                            CameraView(isBraille: viewModel.isBraille) { recognizedText in
                                DispatchQueue.main.async {
                                    viewModel.textInput = recognizedText
                                    viewModel.updateTranslation()
                                    viewModel.isCameraPresented = false
                                }
                            }
                            .edgesIgnoringSafeArea(.all)
                        }
                        
                        Spacer()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 60:20)
                        
                        // Speech recognition button
                        SpeechRecognizerView() { result in
                            viewModel.textInput = result
                            viewModel.updateTranslation()
                        }
                        .accessibilityLabel(NSLocalizedString("speech_button", comment: ""))
                        .accessibilityHint(NSLocalizedString("start_speech_recognition", comment: ""))
                    }
                    .padding(.bottom, 10)
                    
                    // History Section
                    HStack {
                        Text(LocalizedStringKey("history"))
                            .accessibilityLabel(LocalizedStringKey("history"))
                            .accessibilityHint(LocalizedStringKey("history_section_hint"))
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .foregroundColor(.blue)
                            .font(.title)
                            .fontWeight(.bold)
    
                        
                        Spacer()
                        
                        // Toggle to show favorite flashcards
                        Button(action: {
                            viewModel.showingFavorites.toggle()
                        }) {
                            Text(LocalizedStringKey("view_favorites"))
                                .accessibilityLabel(LocalizedStringKey("view_favorites"))
                                .accessibilityHint(LocalizedStringKey("tap_to_open_favorites_view"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.blue)
                               
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    // Flashcard Grid Display
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.flashcardManager.flashcards.sorted(by: { $0.dateAdded > $1.dateAdded })) { flashcard in
                            let flashcardIndex = viewModel.flashcardManager.flashcards.firstIndex(where: { $0.id == flashcard.id })!
                            
                            NavigationLink(destination: FlashcardDetailView(flashcard: viewModel.flashcardManager.flashcards[flashcardIndex])) {
                                FlashcardView(flashcard: $viewModel.flashcardManager.flashcards[flashcardIndex]) { updatedFlashcard in
                                    viewModel.updateFlashcard(updatedFlashcard)
                                }
                                .frame(
                                    width: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 146,
                                    height: UIDevice.current.userInterfaceIdiom == .pad ? 220 : 164
                                )
                                .onLongPressGesture {
                                    viewModel.flashcardToDelete = flashcard
                                    viewModel.showingDeleteConfirmation = true
                                }
                            }
                        }
                    }
                    .foregroundStyle(.blue)
                    .padding()
                }
            }
            .alert(LocalizedStringKey("delete_flashcard_title"), isPresented: $viewModel.showingDeleteConfirmation) {
                Button(LocalizedStringKey("cancel"), role: .cancel) { viewModel.flashcardToDelete = nil }
                    
                Button(LocalizedStringKey("delete"), role: .destructive) {
                    viewModel.deleteFlashcard()
                        
                }
            } message: {
                Text(LocalizedStringKey("delete_flashcard_message"))
                  
            }
            .sheet(isPresented: $viewModel.showingFavorites) {
                FavoritesView(flashcards: $viewModel.flashcardManager.flashcards)
            }
            .navigationTitle(LocalizedStringKey("translate"))
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear.circle")
                            .accessibilityLabel(LocalizedStringKey("settings_button"))
                            .accessibilityHint(LocalizedStringKey("tap_to_open_settings_view"))
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                    }
                    .accessibilityLabel(LocalizedStringKey("settings_button"))
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .scrollContentBackground(.hidden)
            .background(Color("Background"))
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .contentShape(Rectangle())
        }
    }
    
}


#Preview {
    ContentView()
}


