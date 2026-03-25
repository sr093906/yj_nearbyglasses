/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
/*
 * displays the canary, handles animation
 */
struct CanaryPanel: View {
    let isScanning: Bool
    let isAlerting: Bool
    let isFlipped: Bool

    @EnvironmentObject private var l10n: LanguageManager

    private var imageName: String {
        isAlerting ? "CanaryHide" : "Canary"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: isScanning ? "dot.radiowaves.left.and.right" : "pause.circle")
                    .imageScale(.large)
                Text(isScanning ? l10n.text("ios_status_scanning") : l10n.text("ios_status_idle"))
                    .font(.headline)
                if isAlerting {
                    Spacer()
                    Label(l10n.text("ios_status_detected"), systemImage: "exclamationmark.triangle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.yellow)
                }
            }

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))

                if isAlerting {
                    HazardStripes()
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }

                Image(imageName)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: isAlerting ? 280 : 260, height: 180)
                    .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
                    .offset(x: isAlerting ? 6 : 0, y: isAlerting ? 4 : 0)
                    .animation(.easeInOut(duration: 0.25), value: isFlipped)
                    .animation(.easeInOut(duration: 0.2), value: isAlerting)

                if isAlerting {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(.yellow)
                                .padding(.top, 12)
                                .padding(.trailing, 12)
                        }
                        Spacer()
                    }
                }

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: isAlerting ? 8 : 1,
                            dash: isAlerting ? [18, 12] : []
                        )
                    )
                    .foregroundStyle(isAlerting ? Color.yellow : Color.secondary.opacity(0.25))
            }
            .frame(minHeight: 220)

            Text(l10n.text("info_textCanary"))
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }
}

/*
 * generates the warning background
 */
 
private struct HazardStripes: View {
    var body: some View {
        GeometryReader { proxy in
            let diagonal = hypot(proxy.size.width, proxy.size.height) * 1.35

            HStack(spacing: 0) {
                ForEach(0..<24, id: \.self) { index in
                    Rectangle()
                        .fill(index.isMultiple(of: 2)
                              ? Color.yellow.opacity(0.42)
                              : Color.black.opacity(0.14))
                        .frame(width: diagonal / 24, height: diagonal)
                }
            }
            .frame(width: diagonal, height: diagonal)
            .rotationEffect(.degrees(-25))
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .allowsHitTesting(false)
    }
}
