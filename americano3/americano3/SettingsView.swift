import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    @State private var buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(LocalizedStringKey("settings_app_permissions"))){
                    NavigationLink(destination: EmptyView()) {
                        Label {
                            Text(LocalizedStringKey("settings_permissions"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .accessibilityHint(LocalizedStringKey("settings_permissions_hint"))
                        } icon: {
                            Image(systemName: "lock.fill")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.yellow)
                        }
                    }
                    .accessibilityLabel(LocalizedStringKey("settings_permissions"))
                    .accessibilityElement(children: .combine)
                    .simultaneousGesture(TapGesture().onEnded {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    })
                }
                
                
                Section(header: Text(LocalizedStringKey("settings_privacy_section"))) {
                    Button(action: {
                        if let privacyUrl = URL(string: "https://sites.google.com/view/braille-translator-privacy/home-page") {
                            UIApplication.shared.open(privacyUrl)
                        }
                    }) {
                        Label {
                            Text(LocalizedStringKey("settings_privacy_policy"))
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .accessibilityLabel(LocalizedStringKey("settings_privacy_policy"))
                                .accessibilityHint(LocalizedStringKey("settings_privacy_hint"))
                                .foregroundColor(.primary) // Added this line
                        } icon: {
                            Image(systemName: "doc.fill")
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
                
            }
            .navigationTitle(LocalizedStringKey("settings_title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                            .foregroundColor(.gray)
                    }
                    .accessibilityLabel(LocalizedStringKey("settings_close"))
                    .accessibilityHint(LocalizedStringKey("settings_close_hint"))
                }
            }
            .background(Color("Background"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
