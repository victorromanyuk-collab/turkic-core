//
//  ProgressView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

struct ProgressTabView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("interfaceLanguage") private var lang = "ru"
    
    @Query private var allProgress: [UserProgress]
    @Query private var allWords: [Word]
    @Query private var settings: [UserSettings]
    
    private var userSettings: UserSettings? {
        settings.first
    }
    
    private var stats: ProgressStatistics {
        SpacedRepetitionManager.getStatistics(context: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    StreakInfoCard(
                        streak: userSettings?.currentStreak ?? 0,
                        totalTime: userSettings?.totalStudyTimeMinutes ?? 0,
                        lang: lang
                    )
                    
                    LearningStatusCard(stats: stats, lang: lang)
                    
                    AccuracyCard(accuracy: stats.accuracy, lang: lang)
                    
                    LevelProgressCard(allProgress: allProgress, allWords: allWords, lang: lang)
                    
                    ActiveLanguagesCard(
                        activeLanguages: userSettings?.activeLanguages ?? ["kk", "tr", "uz"],
                        lang: lang
                    )
                }
                .padding()
            }
            .background(Color.tcBackgroundLight)
            .navigationTitle(lang == "ru" ? "Прогресс" : "Progress")
        }
    }
}

struct StreakInfoCard: View {
    let streak: Int
    let totalTime: Int
    let lang: String
    
    private var totalHours: Int {
        totalTime / 60
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("🔥")
                        .font(.system(size: 40))
                    Text("\(streak)")
                        .font(.title.bold())
                    Text(lang == "ru" ? "дней" : "days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Text("⏱️")
                        .font(.system(size: 40))
                    Text("\(totalHours)h")
                        .font(.title.bold())
                    Text(lang == "ru" ? "всего" : "total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

struct LearningStatusCard: View {
    let stats: ProgressStatistics
    let lang: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lang == "ru" ? "Статус изучения" : "Learning Status")
                .font(.headline)
            
            VStack(spacing: 12) {
                StatusRow(
                    label: lang == "ru" ? "Освоено" : "Mastered",
                    count: stats.masteredWords,
                    color: .tcSuccess
                )
                
                StatusRow(
                    label: lang == "ru" ? "Повторяю" : "Reviewing",
                    count: stats.reviewingWords,
                    color: .tcPrimary
                )
                
                StatusRow(
                    label: lang == "ru" ? "Учу" : "Learning",
                    count: stats.learningWords,
                    color: .tcWarning
                )
                
                StatusRow(
                    label: lang == "ru" ? "Не начато" : "Not Started",
                    count: stats.newWords,
                    color: .secondary
                )
            }
            
            Divider()
            
            HStack {
                Text(lang == "ru" ? "Всего изучено:" : "Total studied:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(stats.totalStudied)")
                    .font(.headline)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

struct StatusRow: View {
    let label: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(count)")
                .font(.subheadline.bold())
                .foregroundStyle(color)
        }
    }
}

struct AccuracyCard: View {
    let accuracy: Double
    let lang: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lang == "ru" ? "Точность" : "Accuracy")
                .font(.headline)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color(hex: "#E0E0E0"), lineWidth: 12)
                    
                    Circle()
                        .trim(from: 0, to: accuracy)
                        .stroke(
                            Color.tcSuccess,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 4) {
                        Text("\(Int(accuracy * 100))%")
                            .font(.title.bold())
                        Text(lang == "ru" ? "правильно" : "correct")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 120, height: 120)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang == "ru"
                        ? "Отличный результат! Продолжайте в том же духе."
                        : "Great job! Keep up the good work.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if accuracy < 0.7 {
                        Text(lang == "ru"
                            ? "💡 Совет: повторяйте слова регулярно"
                            : "💡 Tip: Review words regularly")
                            .font(.caption)
                            .foregroundStyle(.tcWarning)
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

struct LevelProgressCard: View {
    let allProgress: [UserProgress]
    let allWords: [Word]
    let lang: String
    
    private func wordsForLevel(_ level: String) -> (learned: Int, total: Int) {
        let levelWords = allWords.filter { $0.level == level }
        let learnedIds = allProgress.map { $0.wordId }
        let learnedCount = levelWords.filter { learnedIds.contains($0.id) }.count
        return (learnedCount, levelWords.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lang == "ru" ? "Прогресс по уровням" : "Progress by Level")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(["A1", "A2", "B1", "B2"], id: \.self) { level in
                    let progress = wordsForLevel(level)
                    LevelProgressRow(
                        level: level,
                        learned: progress.learned,
                        total: progress.total
                    )
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

struct LevelProgressRow: View {
    let level: String
    let learned: Int
    let total: Int
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(learned) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(level)
                    .font(.subheadline.bold())
                
                Spacer()
                
                Text("\(learned)/\(total)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#E0E0E0"))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.tcPrimary)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

struct ActiveLanguagesCard: View {
    let activeLanguages: [String]
    let lang: String
    
    private func languageInfo(_ code: String) -> (flag: String, name: String) {
        switch code {
        case "kk": return ("🇰🇿", lang == "ru" ? "Казахский" : "Kazakh")
        case "tr": return ("🇹🇷", lang == "ru" ? "Турецкий" : "Turkish")
        case "uz": return ("🇺🇿", lang == "ru" ? "Узбекский" : "Uzbek")
        case "ky": return ("🇰🇬", lang == "ru" ? "Киргизский" : "Kyrgyz")
        case "tt": return ("🏴", lang == "ru" ? "Татарский" : "Tatar")
        case "az": return ("🇦🇿", lang == "ru" ? "Азербайджанский" : "Azerbaijani")
        default: return ("", "")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lang == "ru" ? "Активные языки" : "Active Languages")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(activeLanguages, id: \.self) { code in
                    let info = languageInfo(code)
                    HStack {
                        Text(info.flag)
                            .font(.title2)
                        Text(info.name)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#F8F9FA"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
    ProgressTabView()
        .modelContainer(for: [Word.self, UserProgress.self, UserSettings.self], inMemory: true)
}
