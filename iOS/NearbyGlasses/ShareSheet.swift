/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
import UIKit
/*
 * basic sharing function
 */
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
