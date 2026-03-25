/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import Foundation
/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 * just an enum to collect all localisations available
 */
enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case english = "en"
    case german = "de"
    case swissGerman = "de-CH"
    case french = "fr"
    case spanish = "es"
    case chinese = "zh"

    var id: String { rawValue }

    var code: String? {
        self == .system ? nil : rawValue
    }

    var displayName: String {
        switch self {
        case .system: return "System default"
        case .english: return "English"
        case .german: return "German"
        case .swissGerman: return "Swiss German"
        case .french: return "French"
        case .spanish: return "Spanish"
        case .chinese: return "Chinese"
        }
    }
}
