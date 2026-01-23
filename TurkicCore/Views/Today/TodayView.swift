//
//  TodayView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("interfaceLanguage") private var lang = "ru"
    
    @Query private var allProgress: [UserProgress]
    @Query private var settings: [UserSettings]
    
    private var userSettings: UserSettings? {
        settings.first
    }
    
    private var dueCount: Int {
        allProgress.filter { $0.isDue }.count
    }
    
    private var masteredCount: Int {
        allProgress.filter { $0.status == .mastered }.count
    }
    
    private var learningCount: Int {
        allProgress.filter { $0.status == .learning || $0.status == .reviewing }.count
    }
    
    private var streak: Int {
        userSettings?.currentStreak ?? 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    StreakCard(days: streak, lang: lang)
                    
                    NavigationLink(destination: LearningSessionView(mode: .new)) {
                        LessonCard(
                            title: lang == "ru" ? "Новый урок" : "New Lesson",
                            subtitle: lang == "ru" ? "5 новых слов" : "5 new words",
                            icon: "play.circle.fill"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if dueCount > 0 {
                        NavigationLink(destination: LearningSessionView(mode: .review)) {
                            LessonCard(
                                title: lang == "ru" ? "Повторение" : "Review",
                                subtitle: "\(dueCount) \(lang == "ru" ? "слов" : "words")",
                                icon: "arrow.clockwise.circle.fill",
                                isReview: true
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    StatsPreview(masteredCount: masteredCount, learningCount: learningCount, lang: lang)
                    
                    DailyGoalCard(
                        goalMinutes: userSettings?.dailyGoalMinutes ?? 15,
                        completedMinutes: min((userSettings?.totalStudyTimeMinutes ?? 0) % 1440, userSettings?.dailyGoalMinutes ?? 15),
                        lang: lang
                    )
                }
                .padding()
            }
            .background(Color.tcBackgroundLight)
            .navigationTitle(lang == "ru" ? "Сегодня" : "Today")
        }
    }
}

struct DailyGoalCard: View {
    let goalMinutes: Int
    let completedMinutes: Int
    let lang: String
    
    private var progress: Double {
        guard goalMinutes > 0 else { return 0 }
        return Double(completedMinutes) / Double(goalMinutes)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(lang == "ru" ? "Цель на сегодня" : "Today's Goal")
                    .font(.headline)
                
                Spacer()
                
                Text("\(completedMinutes)/\(goalMinutes) \(lang == "ru" ? "мин" : "min")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "#E0E0E0"))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.tcPrimary, Color.tcPrimaryDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * min(progress, 1.0))
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Word.self, UserProgress.self, UserSettings.self], inMemory: true)
}
