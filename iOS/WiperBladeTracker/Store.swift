import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [WiperEntry] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier allows up to this many saved entries. Kept comfortably above
    /// the seed data count so a fresh install never trips the paywall.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("wipertrack_entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeLimit
    }

    func add(_ entry: WiperEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: WiperEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: WiperEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            entries = Self.seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([WiperEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Self.seedData()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static func seedData() -> [WiperEntry] {
        [
        WiperEntry(date: Date().addingTimeInterval(-259200), notes: "", side: "Sample Side (front/rear) 1", brand: "Sample Brand 1"),
        WiperEntry(date: Date().addingTimeInterval(-518400), notes: "", side: "Sample Side (front/rear) 2", brand: "Sample Brand 2")
        ]
    }
}
