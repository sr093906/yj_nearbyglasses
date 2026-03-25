/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import Foundation
import Combine
/*
 * class to set and get localisation options
 */
@MainActor
final class LanguageManager: ObservableObject {
    @Published private(set) var catalog: LocalizationCatalog

    private let settings: AppSettings
    private var cancellables = Set<AnyCancellable>()

    init(settings: AppSettings) {
        self.settings = settings
        let code = LanguageManager.resolveLanguageCode(from: settings.selectedLanguage)
        self.catalog = LocalizationCatalog(localeCode: code)

        settings.$selectedLanguageRaw
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let code = LanguageManager.resolveLanguageCode(from: settings.selectedLanguage)
                self.catalog = LocalizationCatalog(localeCode: code)
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func text(_ key: String, _ args: CVarArg...) -> String {
        catalog.text(key, args)
    }

    func html(_ key: String) -> String {
        catalog.text(key)
    }

    private static func resolveLanguageCode(from language: AppLanguage) -> String {
        if let code = language.code { return code }
        return Locale.preferredLanguages.first ?? "en"
    }
}

private extension LocalizationCatalog {
    func text(_ key: String, _ args: [CVarArg]) -> String {
        let format = strings[key] ?? key
        guard !args.isEmpty else { return format }
        let locale = Locale(identifier: localeCode)
        return String(format: format, locale: locale, arguments: args)
    }
}
