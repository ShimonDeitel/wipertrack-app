import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @AppStorage("notifyReminders_wipertrack") private var notifyReminders = true
    @AppStorage("showTips_wipertrack") private var showTips = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminder notifications", isOn: $notifyReminders)
                        .accessibilityIdentifier("toggleReminders")
                    Toggle("Show helpful tips", isOn: $showTips)
                        .accessibilityIdentifier("toggleTips")
                }
                Section("Wiper Blade Tracker Pro") {
                    if purchases.isPro {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            Task { await purchases.purchase() }
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/wipertrack-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/wipertrack-app/terms.html")!)
                    Text("Version 1.0")
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(PurchaseManager())
}
