/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
/*
 * generates the warning background
 */
struct WarningCard: View {
    @EnvironmentObject private var l10n: LanguageManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(l10n.text("warning_title"))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(l10n.text("warning_text"))
                .font(.body.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.orange.opacity(0.18))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.orange.opacity(0.35), lineWidth: 1)
        )
    }
}
