//
//  ContainerView.swift
//  americano3
//
//  Created by Francesco Romeo on 28/01/25.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label(LocalizedStringKey("translate"), systemImage: "translate")
                }
                .accessibilityLabel(LocalizedStringKey("translate_tab"))
                .accessibilityHint(LocalizedStringKey("double_tap_to_switch_to_translate"))
            
            BrailleAlphabetView()
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
    }
}

#Preview {
    ContainerView()
}
