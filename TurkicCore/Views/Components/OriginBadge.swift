//
//  OriginBadge.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct OriginBadge: View {
    let origin: String
    let lang: String
    
    private var color: Color {
        switch origin {
        case "proto-turkic": return .tcTurkicOrigin
        case "arabic": return .tcArabicOrigin
        case "persian": return .tcPersianOrigin
        default: return .tcMixedOrigin
        }
    }
    
    private var text: String {
        switch origin {
        case "proto-turkic": return lang == "ru" ? "Тюркское" : "Turkic"
        case "arabic": return lang == "ru" ? "Арабское" : "Arabic"
        case "persian": return lang == "ru" ? "Персидское" : "Persian"
        default: return lang == "ru" ? "Смешанное" : "Mixed"
        }
    }
    
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 10) {
        OriginBadge(origin: "proto-turkic", lang: "en")
        OriginBadge(origin: "arabic", lang: "en")
        OriginBadge(origin: "persian", lang: "en")
        OriginBadge(origin: "mixed", lang: "ru")
    }
}
