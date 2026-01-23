//
//  StreakCard.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct StreakCard: View {
    let days: Int
    let lang: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text("🔥")
                .font(.system(size: 44))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lang == "ru" ? "Серия" : "Streak")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("\(days) \(lang == "ru" ? "дней" : "days")")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            if days > 0 {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(lang == "ru" ? "Так держать!" : "Keep it up!")
                        .font(.caption.bold())
                        .foregroundStyle(Color.tcPrimary)
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

#Preview {
    VStack {
        StreakCard(days: 7, lang: "ru")
        StreakCard(days: 0, lang: "en")
    }
    .padding()
    .background(Color.tcBackgroundLight)
}
