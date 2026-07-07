import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let proProductID = "com.shimondeitel.wipertrack.pro.monthly"

    @Published var isPro: Bool = false
    @Published var product: Product?
    @Published var isLoading: Bool = false

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { await listenForTransactions() }
        Task { await loadProduct(); await refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await Product.products(for: [Self.proProductID])
            product = products.first
        } catch {
            product = nil
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshEntitlements()
                }
            default:
                break
            }
        } catch {
            // Purchase failed or was cancelled; no-op.
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func listenForTransactions() async {
        for await update in Transaction.updates {
            if case .verified(let transaction) = update {
                await transaction.finish()
                await refreshEntitlements()
            }
        }
    }

    func refreshEntitlements() async {
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.proProductID {
                unlocked = true
            }
        }
        isPro = unlocked
    }
}
