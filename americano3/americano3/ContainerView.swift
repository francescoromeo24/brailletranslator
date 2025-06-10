//
//  ContainerView.swift
//  americano3
//
//  Created by Francesco Romeo on 28/01/25.
//

import SwiftUI

struct ContainerView: View {
    @State private var showGlobalAlert = false
    @State private var alertType: BrailleAlphabetView.AlphabetType? = nil

    var body: some View {
        ZStack {
            TabView {
                ContentView()
                    .tabItem {
                        Label(LocalizedStringKey("translate"), systemImage: "translate")
                    }
                    .accessibilityLabel(LocalizedStringKey("translate_tab"))
                    .accessibilityHint(LocalizedStringKey("double_tap_to_switch_to_translate"))
                
                BrailleAlphabetView(
                    showGlobalAlert: $showGlobalAlert,
                    alertType: $alertType
                )
                .tabItem {
                    Label(LocalizedStringKey("braille_alphabet"), systemImage: "textformat.characters.dottedunderline")
                }
                .accessibilityLabel(LocalizedStringKey("braille_alphabet_tab"))
                .accessibilityHint(LocalizedStringKey("double_tap_to_switch_to_braille_alphabet"))
            }
            .accentColor(.blue)
            .background(Color("Background"))
            .accessibilityElement(children: .contain)
            .accessibilityLabel(LocalizedStringKey("app_navigation"))

            // Overlay e alert globale
            if showGlobalAlert, let type = alertType {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(.all)
                    .onTapGesture { showGlobalAlert = false }
                VStack(spacing: 0) {
                    Text("Usa questo prefisso prima del carattere")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    if type == .uppercase {
                        BraillePatternView(pattern: [false, false, false, false, false, true], label: "Uppercase prefix")
                            .frame(width: 75, height: 90)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 22)
                    } else if type == .numbers {
                        BraillePatternView(pattern: [false, false, true, true, true, true], label: "Number prefix")
                            .frame(width: 75, height: 90)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 22)
                    }
                    Divider()
                        .padding(.horizontal, -16)
                        .padding(.top, 16)
                    Button(action: { showGlobalAlert = false }) {
                        Text("Conferma")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundColor(.blue)
                    }
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(13)
                .frame(width: 270)
                .shadow(radius: 20)
            }
        }
    }
}

#Preview {
    ContainerView()
}
