import Foundation

struct WiperEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var notes: String = ""
    var side: String
    var brand: String
}
