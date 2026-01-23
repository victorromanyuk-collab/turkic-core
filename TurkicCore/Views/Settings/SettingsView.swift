//
//  SettingsView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("interfaceLanguage") private var lang = "ru"
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    
    @Query private var settings: [UserSettings]
    
    private var userSettings: UserSettings {
        if let existing = settings.first {
            return existing
        } else {
            let newSettings = UserSettings()
            modelContext.insert(newSettings)
            return newSettings
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $lang) {
                        Text("Русский").tag("ru")
                        Text("English").tag("en")
                    } label: {
                        Label(
                            lang == "ru" ? "Язык интерфейса" : "Interface Language",
                            systemImage: "globe"
                        )
                    }
                } header: {
                    Text(lang == "ru" ? "Основные" : "General")
                }
                
                Section {
                    NavigationLink(destination: LanguageSelectionView()) {
                        Label(
                            lang == "ru" ? "Изучаемые языки" : "Learning Languages",
                            systemImage: "flag.fill"
                        )
                    }
                    
                    Stepper(value: Binding(
                        get: { userSettings.dailyGoalMinutes },
                        set: { userSettings.dailyGoalMinutes = $0 }
                    ), in: 5...60, step: 5) {
                        HStack {
                            Label(
                                lang == "ru" ? "Цель на день" : "Daily Goal",
                                systemImage: "target"
                            )
                            Spacer()
                            Text("\(userSettings.dailyGoalMinutes) \(lang == "ru" ? "мин" : "min")")
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text(lang == "ru" ? "Обучение" : "Learning")
                }
                
                Section {
                    Toggle(isOn: $soundEnabled) {
                        Label(
                            lang == "ru" ? "Звук" : "Sound",
                            systemImage: "speaker.wave.2.fill"
                        )
                    }
                    
                    Toggle(isOn: $hapticEnabled) {
                        Label(
                            lang == "ru" ? "Вибрация" : "Haptics",
                            systemImage: "hand.tap.fill"
                        )
                    }
                } header: {
                    Text(lang == "ru" ? "Обратная связь" : "Feedback")
                }
                
                Section {
                    NavigationLink(destination: MethodologyView()) {
                        Label(
                            lang == "ru" ? "О методике" : "About Methodology",
                            systemImage: "book.fill"
                        )
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label(
                            lang == "ru" ? "О приложении" : "About App",
                            systemImage: "info.circle.fill"
                        )
                    }
                } header: {
                    Text(lang == "ru" ? "Информация" : "Information")
                }
            }
            .navigationTitle(lang == "ru" ? "Настройки" : "Settings")
        }
    }
}

struct LanguageSelectionView: View {
    @AppStorage("interfaceLanguage") private var lang = "ru"
    @Query private var settings: [UserSettings]
    
    private var userSettings: UserSettings? {
        settings.first
    }
    
    private let languages = [
        ("kk", "🇰🇿", "Kazakh", "Казахский"),
        ("tr", "🇹🇷", "Turkish", "Турецкий"),
        ("uz", "🇺🇿", "Uzbek", "Узбекский"),
        ("ky", "🇰🇬", "Kyrgyz", "Киргизский"),
        ("tt", "🏴", "Tatar", "Татарский"),
        ("az", "🇦🇿", "Azerbaijani", "Азербайджанский")
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(languages, id: \.0) { code, flag, nameEN, nameRU in
                    Button(action: {
                        userSettings?.toggleLanguage(code)
                    }) {
                        HStack {
                            Text(flag)
                                .font(.title2)
                            
                            Text(lang == "ru" ? nameRU : nameEN)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if userSettings?.isLanguageActive(code) ?? false {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.tcPrimary)
                            }
                        }
                    }
                }
            } header: {
                Text(lang == "ru"
                    ? "Выберите языки для изучения (минимум 2)"
                    : "Select languages to learn (minimum 2)")
            } footer: {
                Text(lang == "ru"
                    ? "Вы можете изучать несколько тюркских языков одновременно. Это ускоряет обучение благодаря общей лексике."
                    : "You can learn multiple Turkic languages simultaneously. This accelerates learning due to shared vocabulary.")
            }
        }
        .navigationTitle(lang == "ru" ? "Изучаемые языки" : "Learning Languages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @AppStorage("interfaceLanguage") private var lang = "ru"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.tcPrimary, Color.tcPrimaryDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("turkic.core")
                        .font(.title.bold())
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 32)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(lang == "ru" ? "О приложении" : "About")
                        .font(.headline)
                    
                    Text(lang == "ru"
                        ? "turkic.core — это научно обоснованное приложение для изучения тюркских языков через когнаты. Мы используем факт родства языков, чтобы сделать обучение быстрее и эффективнее."
                        : "turkic.core is a science-based app for learning Turkic languages through cognates. We leverage language relatedness to make learning faster and more effective.")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(lang == "ru" ? "Возможности" : "Features")
                        .font(.headline)
                    
                    FeatureRow(
                        icon: "wifi.slash",
                        title: lang == "ru" ? "100% оффлайн" : "100% Offline",
                        description: lang == "ru"
                            ? "Все работает без интернета"
                            : "Works completely offline"
                    )
                    
                    FeatureRow(
                        icon: "brain.head.profile",
                        title: lang == "ru" ? "Научный подход" : "Science-Based",
                        description: lang == "ru"
                            ? "Spaced repetition и active recall"
                            : "Spaced repetition and active recall"
                    )
                    
                    FeatureRow(
                        icon: "globe.central.south.asia",
                        title: lang == "ru" ? "6 языков" : "6 Languages",
                        description: lang == "ru"
                            ? "Казахский, турецкий, узбекский и другие"
                            : "Kazakh, Turkish, Uzbek, and more"
                    )
                    
                    FeatureRow(
                        icon: "dollarsign.circle",
                        title: lang == "ru" ? "Бесплатно" : "Free",
                        description: lang == "ru"
                            ? "Без подписок и платежей"
                            : "No subscriptions or payments"
                    )
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(lang == "ru" ? "Разработано" : "Developed")
                        .font(.headline)
                    
                    Text("© 2026 turkic.core")
                        .foregroundStyle(.secondary)
                    
                    Text(lang == "ru"
                        ? "Сделано с ❤️ для изучающих тюркские языки"
                        : "Made with ❤️ for Turkic language learners")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            .padding()
        }
        .background(Color.tcBackgroundLight)
        .navigationTitle(lang == "ru" ? "О приложении" : "About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.tcPrimary)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Word.self, UserProgress.self, UserSettings.self], inMemory: true)
}
