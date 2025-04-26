import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    @State private var buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(LocalizedStringKey("settings_app_permissions"))) {
                    Button {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    } label: {
                        Label {
                            Text(LocalizedStringKey("settings_permissions"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .accessibilityHint(LocalizedStringKey("settings_permissions_hint"))
                        } icon: {
                            Image(systemName: "lock.fill")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.yellow)
                        }
                    }
                    .accessibilityLabel(LocalizedStringKey("settings_permissions"))
                    .accessibilityElement(children: .combine)
                }
                
                Section(header: Text(LocalizedStringKey("settings_privacy_section")))
                    {
                    Button(action: {
                        UIApplication.shared.open(localizedPrivacyPolicyURL())
                    }) {
                        Label {
                            Text(LocalizedStringKey("settings_privacy_policy"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .accessibilityLabel(LocalizedStringKey("settings_privacy_policy"))
                                .accessibilityHint(LocalizedStringKey("settings_privacy_hint"))
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "doc.fill")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("Background"))
            .navigationTitle(LocalizedStringKey("settings_title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel(LocalizedStringKey("settings_close"))
                    .accessibilityHint(LocalizedStringKey("settings_close_hint"))
                }
            }
        }
    }
    
    // Funzione per selezionare l'URL della privacy policy in base alla lingua
    func localizedPrivacyPolicyURL() -> URL {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        
        switch languageCode {
        case "it":
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/braille-translator-privacy-policy-it")!
        case "fr":
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/braille-translator-privacy-policy-fr")!
        case "de":
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/braille-translator-privacy-policy-de")!
        case "pt":
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/braille-translator-privacy-policy-pt")!
        case "pt-BR":
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/braille-translator-privacy-policy-br")!
        default:
            return URL(string: "https://sites.google.com/view/braille-translator-privacy/home-page")! // fallback inglese
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
