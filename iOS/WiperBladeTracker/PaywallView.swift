import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Wiper Blade Tracker Pro")
                    .font(Theme.titleFont)
                Text("Size/part number memory per vehicle and multi-car support")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal)
                Spacer()
                if let product = purchases.product {
                    Button {
                        Task { await purchases.purchase() }
                    } label: {
                        Text("Unlock for \(product.displayPrice) (per month)")
                            .font(Theme.bodyFont.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("purchaseButton")
                    .padding(.horizontal)
                } else {
                    ProgressView()
                }
                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywallRestoreButton")
                Button("Not now") { dismiss() }
                    .accessibilityIdentifier("paywallDismissButton")
                    .padding(.bottom)
            }
            .padding()
            .background(Theme.background.ignoresSafeArea())
        }
        .task { await purchases.loadProduct() }
    }
}

#Preview {
    PaywallView().environmentObject(PurchaseManager())
}
