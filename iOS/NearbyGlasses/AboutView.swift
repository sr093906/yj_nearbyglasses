/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
import Foundation
/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 * generates the about screen
 */
struct AboutView: View {
    @EnvironmentObject private var l10n: LanguageManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(l10n.text("summaryApp"))
                    .font(.headline)

                Text(l10n.text("summaryMethod"))
                    .foregroundStyle(.secondary)

                Text(liabilityAttributedString)
                    .font(.body)

                Text(l10n.text("ios_about_footer"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(l10n.text("ios_about_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var liabilityAttributedString: AttributedString {
        let html = l10n.html("summaryLiability")

        guard let data = html.data(using: .utf8),
              let nsAttributed = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              ),
              var attributed = try? AttributedString(nsAttributed, including: \.uiKit)
        else {
            return AttributedString(html.replacingOccurrences(of: "<br/>", with: "\n"))
        }

        var container = AttributeContainer()
        container.font = .body
        container.foregroundColor = .primary
        attributed.mergeAttributes(container)

        return attributed
    }
}
