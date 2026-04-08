import SwiftUI

extension Color {
    /// Returns a hex string like "#RRGGBB" or "#RRGGBBAA" (uppercase).
    func toHexString(includeAlpha: Bool = false) -> String? {
        #if os(iOS) || os(tvOS) || os(watchOS)
        typealias NativeColor = UIColor
        #elseif os(macOS)
        typealias NativeColor = NSColor
        #else
        typealias NativeColor = UIColor
        #endif

        let native = NativeColor(self)

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard native.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let R = UInt8(clamping: Int(round(r * 255)))
        let G = UInt8(clamping: Int(round(g * 255)))
        let B = UInt8(clamping: Int(round(b * 255)))
        let A = UInt8(clamping: Int(round(a * 255)))

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02X%02X", R, G, B)
        }
    }

    /// Initialize from hex strings "#RRGGBB" or "#RRGGBBAA" (case-insensitive).
    init?(hex: String) {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard s.hasPrefix("#") else { return nil }
        let hexDigits = String(s.dropFirst())
        guard hexDigits.count == 6 || hexDigits.count == 8 else { return nil }

        var value: UInt64 = 0
        guard Scanner(string: hexDigits).scanHexInt64(&value) else { return nil }

        let r, g, b, a: Double
        if hexDigits.count == 6 {
            r = Double((value >> 16) & 0xFF) / 255.0
            g = Double((value >> 8) & 0xFF) / 255.0
            b = Double(value & 0xFF) / 255.0
            a = 1.0
        } else {
            r = Double((value >> 24) & 0xFF) / 255.0
            g = Double((value >> 16) & 0xFF) / 255.0
            b = Double((value >> 8) & 0xFF) / 255.0
            a = Double(value & 0xFF) / 255.0
        }

        self = Color(red: r, green: g, blue: b, opacity: a)
    }
}
