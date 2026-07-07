import SwiftUI

/// Wiper Blade Tracker — bespoke palette tuned to its domain.
enum Theme {
    static let accent = Color(red: 0.243, green: 0.557, blue: 0.871)
    static let background = Color(red: 0.039, green: 0.078, blue: 0.125)
    static let cardBackground = Color(.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
