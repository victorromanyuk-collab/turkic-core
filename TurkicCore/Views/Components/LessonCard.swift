//
//  LessonCard.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct LessonCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let isReview: Bool
    
    init(title: String, subtitle: String, icon: String, isReview: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isReview = isReview
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(
                        colors: isReview ? [Color.tcWarning, Color.tcWarning.opacity(0.8)] : [Color.tcPrimary, Color.tcPrimaryDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.headline)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

#Preview {
    VStack {
        LessonCard(title: "New Lesson", subtitle: "5 new words", icon: "play.circle.fill")
        LessonCard(title: "Review", subtitle: "10 words due", icon: "arrow.clockwise.circle.fill", isReview: true)
    }
    .padding()
    .background(Color.tcBackgroundLight)
}
