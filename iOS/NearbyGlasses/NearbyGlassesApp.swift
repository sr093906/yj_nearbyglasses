/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
/*
 * boilerplate main
 */
@main
struct NearbyGlassesApp: App {
    @StateObject private var settings: AppSettings
    @StateObject private var languageManager: LanguageManager
    @StateObject private var scannerStore: ScannerStore

    init() {
        let settings = AppSettings()
        let languageManager = LanguageManager(settings: settings)
        _settings = StateObject(wrappedValue: settings)
        _languageManager = StateObject(wrappedValue: languageManager)
        _scannerStore = StateObject(wrappedValue: ScannerStore(settings: settings, languageManager: languageManager))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(languageManager)
                .environmentObject(scannerStore)
        }
    }
}
