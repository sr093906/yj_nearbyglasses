/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
 import Foundation
/*
 * helper for the log entries
 */
struct LogEntry: Identifiable, Hashable {
    enum Kind: String {
        case detection
        case debug
        case info
    }

    let id: UUID
    let timestamp: Date
    let text: String
    let kind: Kind

    init(id: UUID = UUID(), timestamp: Date = .now, text: String, kind: Kind) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
        self.kind = kind
    }
}
