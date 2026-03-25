/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import Foundation
/*
 * handles BLE detections
 */
struct DetectionEvent: Identifiable, Codable, Hashable {
    let id: UUID
    let timestamp: Date
    let deviceIdentifier: String
    let deviceName: String?
    let rssi: Int
    let companyIDHex: String?
    let companyName: String
    let manufacturerDataHex: String?
    let detectionReason: String

    init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        deviceIdentifier: String,
        deviceName: String?,
        rssi: Int,
        companyIDHex: String?,
        companyName: String,
        manufacturerDataHex: String?,
        detectionReason: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.deviceIdentifier = deviceIdentifier
        self.deviceName = deviceName
        self.rssi = rssi
        self.companyIDHex = companyIDHex
        self.companyName = companyName
        self.manufacturerDataHex = manufacturerDataHex
        self.detectionReason = detectionReason
    }

    func logLine(using languageManager: LanguageManager) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: languageManager.catalog.localeCode)
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: timestamp)
        let name = deviceName ?? languageManager.text("log_unknown_device")
        return languageManager.text("log_detection_line", time, name, rssi, detectionReason)
    }
}
