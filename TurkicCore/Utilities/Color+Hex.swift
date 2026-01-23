//
//  Color+Hex.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme Colors
extension Color {
    // Primary
    static let tcPrimary = Color(hex: "#E67E22")
    static let tcPrimaryDark = Color(hex: "#D35400")
    
    // Semantic
    static let tcSuccess = Color(hex: "#16A085")
    static let tcError = Color(hex: "#E74C3C")
    static let tcWarning = Color(hex: "#F39C12")
    
    // Background (Light)
    static let tcBackgroundLight = Color(hex: "#FBF8F3")
    static let tcCardLight = Color.white
    static let tcTextPrimary = Color(hex: "#2C3E50")
    static let tcTextSecondary = Color(hex: "#7F8C8D")
    
    // Background (Dark)
    static let tcBackgroundDark = Color(hex: "#1A1A1A")
    static let tcCardDark = Color(hex: "#2C2C2C")
    
    // Origin colors
    static let tcTurkicOrigin = Color(hex: "#16A085")
    static let tcArabicOrigin = Color(hex: "#E67E22")
    static let tcPersianOrigin = Color(hex: "#9B59B6")
    static let tcMixedOrigin = Color(hex: "#95A5A6")
}
