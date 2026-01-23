//
//  WordCardView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

struct WordCardView: View {
    let word: Word
    @AppStorage("interfaceLanguage") private var lang = "ru"
    @Query private var settings: [UserSettings]
    
    private var userSettings: UserSettings? {
        settings.first
    }
    
    private var activeLanguages: [String] {
        userSettings?.activeLanguages ?? ["kk", "tr", "uz"]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(lang == "ru" ? word.ru : word.en)
                        .font(.system(size: 42, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text(word.pos.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#F0F0F0"))
                        .clipShape(Capsule())
                }
                
                OriginBadge(origin: word.origin, lang: lang)
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(spacing: 16) {
                    if activeLanguages.contains("kk") {
                        LanguageRow(
                            flag: "🇰🇿",
                            name: lang == "ru" ? "Казахский" : "Kazakh",
                            native: word.kkNative,
                            latin: word.kkLatin,
                            ipa: word.kkIPA,
                            ttsCode: "kk-KZ"
                        )
                    }
                    
                    if activeLanguages.contains("tr") {
                        LanguageRow(
                            flag: "🇹🇷",
                            name: lang == "ru" ? "Турецкий" : "Turkish",
                            native: word.trNative,
                            latin: nil,
                            ipa: word.trIPA,
                            ttsCode: "tr-TR"
                        )
                    }
                    
                    if activeLanguages.contains("uz") {
                        LanguageRow(
                            flag: "🇺🇿",
                            name: lang == "ru" ? "Узбекский" : "Uzbek",
                            native: word.uzNative,
                            latin: nil,
                            ipa: word.uzIPA,
                            ttsCode: "uz-UZ"
                        )
                    }
                    
                    if activeLanguages.contains("ky") {
                        LanguageRow(
                            flag: "🇰🇬",
                            name: lang == "ru" ? "Киргизский" : "Kyrgyz",
                            native: word.kyNative,
                            latin: word.kyLatin,
                            ipa: word.kyIPA,
                            ttsCode: "ky-KG"
                        )
                    }
                    
                    if activeLanguages.contains("tt") {
                        LanguageRow(
                            flag: "🏴",
                            name: lang == "ru" ? "Татарский" : "Tatar",
                            native: word.ttNative,
                            latin: word.ttLatin,
                            ipa: word.ttIPA,
                            ttsCode: "tt-RU"
                        )
                    }
                    
                    if activeLanguages.contains("az") {
                        LanguageRow(
                            flag: "🇦🇿",
                            name: lang == "ru" ? "Азербайджанский" : "Azerbaijani",
                            native: word.azNative,
                            latin: nil,
                            ipa: word.azIPA,
                            ttsCode: "az-AZ"
                        )
                    }
                }
                
                CognateScoreView(score: word.cognateScore, lang: lang)
                
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundStyle(Color.tcPrimary)
                    
                    Text(word.level)
                        .font(.headline)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(lang == "ru" ? "Частотность:" : "Frequency:")
                        .foregroundStyle(.secondary)
                    
                    Text("#\(word.frequency)")
                        .font(.headline)
                }
                .padding()
                .background(Color(hex: "#F8F9FA"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .background(Color.tcBackgroundLight)
        .navigationTitle(lang == "ru" ? "Слово" : "Word")
        .navigationBarTitleDisplayMode(.inline)
    }
}
