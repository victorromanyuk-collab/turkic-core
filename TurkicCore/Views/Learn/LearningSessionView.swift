//
//  LearningSessionView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

enum SessionMode {
    case new
    case review
    case mixed
}

struct LearningSessionView: View {
    let mode: SessionMode
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("interfaceLanguage") private var lang = "ru"
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    
    @Query private var settings: [UserSettings]
    
    @State private var words: [Word] = []
    @State private var currentIndex = 0
    @State private var showingAnswer = false
    @State private var sessionComplete = false
    @State private var correctCount = 0
    @State private var incorrectCount = 0
    @State private var startTime = Date()
    
    private var userSettings: UserSettings? {
        settings.first
    }
    
    private var activeLanguages: [String] {
        userSettings?.activeLanguages ?? ["kk", "tr", "uz"]
    }
    
    private var currentWord: Word? {
        guard currentIndex < words.count else { return nil }
        return words[currentIndex]
    }
    
    private var progress: Double {
        guard !words.isEmpty else { return 0 }
        return Double(currentIndex) / Double(words.count)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "#E0E0E0"))
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.tcPrimary, Color.tcPrimaryDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 4)
            
            if sessionComplete {
                SessionCompleteView(
                    correctCount: correctCount,
                    incorrectCount: incorrectCount,
                    totalTime: Int(Date().timeIntervalSince(startTime) / 60),
                    lang: lang,
                    onDismiss: { dismiss() }
                )
            } else if let word = currentWord {
                FlashcardView(
                    word: word,
                    showingAnswer: showingAnswer,
                    lang: lang,
                    activeLanguages: activeLanguages,
                    onFlip: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showingAnswer.toggle()
                        }
                        if hapticEnabled {
                            HapticManager.light()
                        }
                    },
                    onCorrect: {
                        recordAnswer(correct: true)
                    },
                    onIncorrect: {
                        recordAnswer(correct: false)
                    }
                )
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.tcBackgroundLight)
        .navigationTitle(modeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(lang == "ru" ? "Выйти" : "Exit") {
                    dismiss()
                }
            }
        }
        .onAppear {
            loadWords()
        }
    }
    
    private var modeTitle: String {
        switch mode {
        case .new:
            return lang == "ru" ? "Новые слова" : "New Words"
        case .review:
            return lang == "ru" ? "Повторение" : "Review"
        case .mixed:
            return lang == "ru" ? "Обучение" : "Learning"
        }
    }
    
    private func loadWords() {
        let newCount = mode == .review ? 0 : 5
        let reviewCount = mode == .new ? 0 : 10
        
        words = SpacedRepetitionManager.getWordsForSession(
            context: modelContext,
            newCount: newCount,
            reviewCount: reviewCount
        )
    }
    
    private func recordAnswer(correct: Bool) {
        guard let word = currentWord else { return }
        
        if correct {
            correctCount += 1
            if hapticEnabled {
                HapticManager.success()
            }
        } else {
            incorrectCount += 1
            if hapticEnabled {
                HapticManager.error()
            }
        }
        
        SpacedRepetitionManager.recordAnswer(
            context: modelContext,
            wordId: word.id,
            correct: correct
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentIndex + 1 < words.count {
                withAnimation {
                    currentIndex += 1
                    showingAnswer = false
                }
            } else {
                withAnimation {
                    sessionComplete = true
                }
                
                let sessionMinutes = Int(Date().timeIntervalSince(startTime) / 60)
                userSettings?.addStudyTime(minutes: max(1, sessionMinutes))
            }
        }
    }
}

struct FlashcardView: View {
    let word: Word
    let showingAnswer: Bool
    let lang: String
    let activeLanguages: [String]
    let onFlip: () -> Void
    let onCorrect: () -> Void
    let onIncorrect: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                if !showingAnswer {
                    VStack(spacing: 24) {
                        Text(lang == "ru" ? word.ru : word.en)
                            .font(.system(size: 48, weight: .bold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                        
                        OriginBadge(origin: word.origin, lang: lang)
                        
                        Text(lang == "ru" ? "Нажмите, чтобы увидеть переводы" : "Tap to see translations")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(32)
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                    .rotation3DEffect(
                        .degrees(showingAnswer ? 90 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
                
                if showingAnswer {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(activeLanguages, id: \.self) { langCode in
                                LanguageAnswerRow(
                                    word: word,
                                    langCode: langCode,
                                    lang: lang
                                )
                            }
                            
                            CognateScoreView(score: word.cognateScore, lang: lang)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                    .rotation3DEffect(
                        .degrees(showingAnswer ? 0 : -90),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
            }
            .onTapGesture {
                if !showingAnswer {
                    onFlip()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            if showingAnswer {
                HStack(spacing: 16) {
                    Button(action: onIncorrect) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text(lang == "ru" ? "Не знал" : "Don't Know")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.tcError)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button(action: onCorrect) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(lang == "ru" ? "Знал" : "Know")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.tcSuccess)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.tcBackgroundLight)
    }
}

struct LanguageAnswerRow: View {
    let word: Word
    let langCode: String
    let lang: String
    
    private var languageInfo: (flag: String, name: String) {
        switch langCode {
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
        HStack {
            Text(languageInfo.flag)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(languageInfo.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(word.getNative(for: langCode))
                    .font(.title3.bold())
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SessionCompleteView: View {
    let correctCount: Int
    let incorrectCount: Int
    let totalTime: Int
    let lang: String
    let onDismiss: () -> Void
    
    private var totalWords: Int {
        correctCount + incorrectCount
    }
    
    private var accuracy: Double {
        guard totalWords > 0 else { return 0 }
        return Double(correctCount) / Double(totalWords)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.tcSuccess.opacity(0.2), Color.tcSuccess.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.tcSuccess)
            }
            
            VStack(spacing: 8) {
                Text(lang == "ru" ? "Отличная работа!" : "Great Job!")
                    .font(.title.bold())
                
                Text(lang == "ru" ? "Сессия завершена" : "Session Complete")
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ResultStatCard(
                        value: "\(correctCount)",
                        label: lang == "ru" ? "Правильно" : "Correct",
                        color: .tcSuccess
                    )
                    
                    ResultStatCard(
                        value: "\(incorrectCount)",
                        label: lang == "ru" ? "Неправильно" : "Incorrect",
                        color: .tcError
                    )
                }
                
                HStack(spacing: 16) {
                    ResultStatCard(
                        value: "\(Int(accuracy * 100))%",
                        label: lang == "ru" ? "Точность" : "Accuracy",
                        color: .tcPrimary
                    )
                    
                    ResultStatCard(
                        value: "\(totalTime)",
                        label: lang == "ru" ? "Минут" : "Minutes",
                        color: .tcWarning
                    )
                }
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Text(lang == "ru" ? "Завершить" : "Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.tcPrimary, Color.tcPrimaryDark],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .padding()
        .background(Color.tcBackgroundLight)
    }
}

struct ResultStatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
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
