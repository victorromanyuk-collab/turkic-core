//
//  CognateScoreView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct CognateScoreView: View {
    let score: Double
    let lang: String
    
    private var scoreColor: Color {
        if score >= 0.8 {
            return .tcSuccess
        } else if score >= 0.5 {
            return .tcWarning
        } else {
            return .tcError
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(lang == "ru" ? "Схожесть между языками" : "Cross-language similarity")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(Int(score * 100))%")
                    .font(.title2.bold())
                    .foregroundStyle(scoreColor)
            }
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#E0E0E0"))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(scoreColor)
                        .frame(width: geometry.size.width * score)
                }
            }
            .frame(height: 8)
            .frame(maxWidth: 120)
        }
        .padding()
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 10) {
        CognateScoreView(score: 0.95, lang: "en")
        CognateScoreView(score: 0.7, lang: "ru")
        CognateScoreView(score: 0.4, lang: "en")
    }
    .padding()
}
