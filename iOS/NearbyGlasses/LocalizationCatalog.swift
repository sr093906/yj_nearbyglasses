/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import Foundation
/*
 * generates the whole localisation from jsons
 * I know this is not the Xcode-way, but I got lazy when porting this app from the Android codebase
 */
struct LocalizationCatalog {
    let localeCode: String
    let strings: [String: String]

    init(localeCode: String) {
        self.localeCode = localeCode
        self.strings = Self.loadStrings(for: localeCode) ?? Self.loadStrings(for: "en") ?? [:]
    }

    func text(_ key: String, _ args: CVarArg...) -> String {
        let format = strings[key] ?? key
        guard !args.isEmpty else { return format }
        let locale = Locale(identifier: localeCode)
        return String(format: format, locale: locale, arguments: args)
    }

    private static func loadStrings(for localeCode: String) -> [String: String]? {
        let candidates = [
            localeCode,
            localeCode.replacingOccurrences(of: "_", with: "-"),
            localeCode.components(separatedBy: "-").first ?? localeCode
        ].filter { !$0.isEmpty }

        for candidate in candidates {
            let urls: [URL?] = [
                Bundle.main.url(forResource: candidate, withExtension: "json", subdirectory: "Localization"),
                Bundle.main.url(forResource: candidate, withExtension: "json")
            ]

            for url in urls {
                guard let url else { continue }
                if let data = try? Data(contentsOf: url),
                   let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
                    return decoded
                }
            }
        }

        return nil
    }
}
