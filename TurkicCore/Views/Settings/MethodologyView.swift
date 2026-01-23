//
//  MethodologyView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct MethodologyView: View {
    @AppStorage("interfaceLanguage") private var lang = "ru"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(lang == "ru" ? "Как работает turkic.core" : "How turkic.core works")
                        .font(.title.bold())
                    
                    Text(lang == "ru"
                        ? "Научный подход к изучению тюркских языков"
                        : "Science-based Turkic language learning")
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                MethodologySection(
                    icon: "🎯",
                    title: lang == "ru" ? "Один концепт — шесть языков" : "One concept — six languages",
                    content: lang == "ru"
                        ? "Тюркские языки — это семья. Казахский, турецкий, узбекский, киргизский, татарский и азербайджанский делят 60-80% базовой лексики.\n\nМы используем это: вместо того чтобы учить «воду» 6 раз на 6 языках, вы учите её один раз и видите, как она звучит везде."
                        : "Turkic languages are a family. Kazakh, Turkish, Uzbek, Kyrgyz, Tatar, and Azerbaijani share 60-80% of their core vocabulary.\n\nWe leverage this: instead of learning 'water' 6 times in 6 languages, you learn it once and see how it sounds everywhere."
                )
                
                MethodologySection(
                    icon: "📊",
                    title: lang == "ru" ? "Научный подход" : "Scientific approach",
                    content: lang == "ru"
                        ? "• Частотность: сначала самые нужные слова (2500 слов = 90% повседневной речи)\n\n• Интервальное повторение: алгоритм напоминает слова именно тогда, когда вы их почти забыли\n\n• Активное вспоминание: вы вспоминаете, а не просто перечитываете — это в 2 раза эффективнее\n\n• Чередование: микс языков и тем в каждой сессии улучшает память на 40%"
                        : "• Frequency-first: most useful words first (2500 words = 90% of daily speech)\n\n• Spaced repetition: algorithm reminds you right before you forget\n\n• Active recall: retrieving beats re-reading — it's 2x more effective\n\n• Interleaving: mixing languages and topics improves long-term memory by 40%"
                )
                
                MethodologySection(
                    icon: "🧠",
                    title: lang == "ru" ? "Уровни CEFR" : "CEFR Levels",
                    content: lang == "ru"
                        ? "A1 → Выживание (500 слов)\nA2 → Повседневность (1100 слов)\nB1 → Свободное общение (1800 слов)\nB2 → Нюансы и аргументация (2500 слов)"
                        : "A1 → Survival (500 words)\nA2 → Daily life (1100 words)\nB1 → Independent (1800 words)\nB2 → Fluent discussion (2500 words)"
                )
                
                MethodologySection(
                    icon: "⏱️",
                    title: lang == "ru" ? "10-15 минут в день" : "10-15 minutes daily",
                    content: lang == "ru"
                        ? "Короткие ежедневные сессии эффективнее редких марафонов. Постоянство важнее интенсивности."
                        : "Short daily sessions beat occasional marathons. Consistency matters more than intensity."
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(lang == "ru" ? "Научные источники:" : "Scientific sources:")
                        .font(.headline)
                    
                    Text("• Nation (2001) — Vocabulary learning\n• Krashen (1982) — Input hypothesis\n• Ebbinghaus (1885) — Spaced repetition\n• Bjork (1994) — Desirable difficulties\n• de Groot (1992) — Cognate facilitation")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(hex: "#F8F9FA"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .background(Color.tcBackgroundLight)
        .navigationTitle(lang == "ru" ? "О методике" : "Methodology")
    }
}

struct MethodologySection: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(icon)
                    .font(.title)
                Text(title)
                    .font(.headline)
            }
            
            Text(content)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    NavigationStack {
        MethodologyView()
    }
}
