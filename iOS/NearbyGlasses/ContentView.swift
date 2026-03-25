/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import SwiftUI
/*
 * generates the main screen
 */
 
struct ContentView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var l10n: LanguageManager
    @EnvironmentObject private var scannerStore: ScannerStore
    @Environment(\.scenePhase) private var scenePhase

    @State private var showingSettings = false
    @State private var shareURL: URL?
    @State private var showingClearDialog = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    WarningCard()

                    VStack(spacing: 12) {
                        Button(action: toggleScanning) {
                            HStack {
                                Image(systemName: scannerStore.isScanning ? "stop.fill" : "dot.radiowaves.left.and.right")
                                    .imageScale(.large)
                                Text(scannerStore.isScanning ? l10n.text("stopScanning") : l10n.text("startScanning"))
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.accentColor)

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: scannerStore.isScanning ? "antenna.radiowaves.left.and.right" : "bluetooth.slash")
                                .foregroundStyle(scannerStore.isScanning ? .primary : .secondary)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(scannerStore.isScanning ? l10n.text("textScanningCanary") : l10n.text("notScanningCanary"))
                                    .font(.headline)
                                Text(l10n.text("ios_foreground_only_notice"))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                if let status = scannerStore.statusMessage {
                                    Text(status)
                                        .font(.footnote)
                                        .foregroundStyle(.red)
                                }
                            }
                            Spacer()
                        }
                    }

                    CanaryPanel(
                        isScanning: scannerStore.isScanning,
                        isAlerting: scannerStore.canaryDetected,
                        isFlipped: scannerStore.canaryFlipped
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(l10n.text("ios_log_section_title"))
                                .font(.headline)
                            Spacer()
                            if !scannerStore.logEntries.isEmpty {
                                Menu {
                                    Button(l10n.text("ios_export_menu"), systemImage: "square.and.arrow.up") { exportLog() }
                                    Button(l10n.text("ios_clear_menu"), systemImage: "trash", role: .destructive) { showingClearDialog = true }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .imageScale(.large)
                                }
                            }
                        }

                        if scannerStore.logEntries.isEmpty {
                            Text(l10n.text("ios_log_empty"))
                                .font(.body)
                                .foregroundStyle(.secondary)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(scannerStore.logEntries) { entry in
                                    Text(entry.text)
                                        .font(.system(.footnote, design: .monospaced))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(10)
                                        .background(background(for: entry.kind))
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                }
                            }
                        }
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
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            //.navigationTitle(l10n.text("app_name"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: Binding(
                get: { shareURL != nil },
                set: { if !$0 { shareURL = nil } }
            )) {
                if let url = shareURL {
                    ShareSheet(items: [url])
                }
            }
            .confirmationDialog(
                l10n.text("ios_clear_confirm_title"),
                isPresented: $showingClearDialog,
                titleVisibility: .visible
            ) {
                Button(l10n.text("dialog_clear"), role: .destructive) {
                    scannerStore.clearLogs()
                }
                Button(l10n.text("ios_cancel"), role: .cancel) {}
            } message: {
                Text(l10n.text("ios_clear_confirm_message"))
            }
            .onChange(of: scenePhase) { newValue in
                guard newValue != .active, scannerStore.isScanning else { return }
                scannerStore.stopScanning(backgrounded: true)
            }
        }
    }

    private func toggleScanning() {
        if scannerStore.isScanning {
            scannerStore.stopScanning()
        } else {
            scannerStore.startScanning()
        }
    }

    private func exportLog() {
        do {
            shareURL = try scannerStore.exportLogURL()
        } catch {
            scannerStore.statusMessage = error.localizedDescription
        }
    }

    @ViewBuilder
    private func background(for kind: LogEntry.Kind) -> some View {
        switch kind {
        case .detection:
            Color.orange.opacity(0.14)
        case .debug:
            Color.blue.opacity(0.10)
        case .info:
            Color.gray.opacity(0.12)
        }
    }
}
