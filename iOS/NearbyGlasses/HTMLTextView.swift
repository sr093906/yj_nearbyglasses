/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
import UIKit
/*
 * generates the html view for the license and liability info
 */
struct HTMLTextView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.adjustsFontForContentSizeCategory = true
        view.dataDetectorTypes = [.link]
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        guard let data = html.data(using: .utf8) else {
            uiView.text = html
            return
        }

        if let attributed = try? NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            let font = UIFont.preferredFont(forTextStyle: .body)
            let fullRange = NSRange(location: 0, length: attributed.length)
            attributed.addAttributes([
                .font: font,
                .foregroundColor: UIColor.label
            ], range: fullRange)
            uiView.attributedText = attributed
        } else {
            uiView.text = html
        }
    }
}
