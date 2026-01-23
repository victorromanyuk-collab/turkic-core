//
//  StatsPreview.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct StatsPreview: View {
    let masteredCount: Int
    let learningCount: Int
    let lang: String
    
    var body: some View {
        HStack(spacing: 16) {
            StatBox(
                value: masteredCount,
                label: lang == "ru" ? "Освоено" : "Mastered",
                color: .tcSuccess
            )
            
            StatBox(
                value: learningCount,
                label: lang == "ru" ? "Учу" : "Learning",
                color: .tcWarning
            )
        }
    }
}

struct StatBox: View {
    let value: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(value)")
                .font(.title.bold())
                .foregroundStyle(color)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    StatsPreview(masteredCount: 42, learningCount: 15, lang: "en")
        .padding()
        .background(Color.tcBackgroundLight)
}
