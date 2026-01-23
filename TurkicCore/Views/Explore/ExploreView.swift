//
//  ExploreView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

struct ExploreView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("interfaceLanguage") private var lang = "ru"
    
    @Query(sort: \Word.frequency) private var allWords: [Word]
    @State private var searchText = ""
    @State private var selectedLevel: String? = nil
    @State private var selectedOrigin: String? = nil
    
    private let levels = ["A1", "A2", "B1", "B2"]
    private let origins = ["proto-turkic", "arabic", "persian", "mixed"]
    
    private var filteredWords: [Word] {
        var words = allWords
        
        if !searchText.isEmpty {
            words = words.filter { word in
                word.ru.localizedCaseInsensitiveContains(searchText) ||
                word.en.localizedCaseInsensitiveContains(searchText) ||
                word.kkNative.localizedCaseInsensitiveContains(searchText) ||
                word.trNative.localizedCaseInsensitiveContains(searchText) ||
                word.uzNative.localizedCaseInsensitiveContains(searchText) ||
                word.kyNative.localizedCaseInsensitiveContains(searchText) ||
                word.ttNative.localizedCaseInsensitiveContains(searchText) ||
                word.azNative.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let level = selectedLevel {
            words = words.filter { $0.level == level }
        }
        
        if let origin = selectedOrigin {
            words = words.filter { $0.origin == origin }
        }
        
        return words
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField(
                        lang == "ru" ? "Поиск слов..." : "Search words...",
                        text: $searchText
                    )
                    .textFieldStyle(.plain)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "#F0F0F0"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(levels, id: \.self) { level in
                            FilterChip(
                                title: level,
                                isSelected: selectedLevel == level,
                                color: .tcPrimary,
                                action: {
                                    selectedLevel = selectedLevel == level ? nil : level
                                }
                            )
                        }
                        
                        Divider()
                            .frame(height: 30)
                        
                        ForEach(origins, id: \.self) { origin in
                            FilterChip(
                                title: originLabel(origin),
                                isSelected: selectedOrigin == origin,
                                color: originColor(origin),
                                action: {
                                    selectedOrigin = selectedOrigin == origin ? nil : origin
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                if filteredWords.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        
                        Text(lang == "ru" ? "Слова не найдены" : "No words found")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List(filteredWords) { word in
                        NavigationLink(destination: WordCardView(word: word)) {
                            WordRowView(word: word, lang: lang)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color.tcBackgroundLight)
            .navigationTitle(lang == "ru" ? "Словарь" : "Dictionary")
        }
    }
    
    private func originLabel(_ origin: String) -> String {
        switch origin {
        case "proto-turkic": return lang == "ru" ? "Тюркское" : "Turkic"
        case "arabic": return lang == "ru" ? "Арабское" : "Arabic"
        case "persian": return lang == "ru" ? "Персидское" : "Persian"
        case "mixed": return lang == "ru" ? "Смешанное" : "Mixed"
        default: return origin
        }
    }
    
    private func originColor(_ origin: String) -> Color {
        switch origin {
        case "proto-turkic": return .tcTurkicOrigin
        case "arabic": return .tcArabicOrigin
        case "persian": return .tcPersianOrigin
        default: return .tcMixedOrigin
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .tcPrimary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color(hex: "#F0F0F0"))
                .clipShape(Capsule())
        }
    }
}

struct WordRowView: View {
    let word: Word
    let lang: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(word.level)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.tcPrimary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lang == "ru" ? word.ru : word.en)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Text(word.kkNative)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(word.trNative)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(word.uzNative)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
            
            Spacer()
            
            Circle()
                .fill(originColor(word.origin))
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private func originColor(_ origin: String) -> Color {
        switch origin {
        case "proto-turkic": return .tcTurkicOrigin
        case "arabic": return .tcArabicOrigin
        case "persian": return .tcPersianOrigin
        default: return .tcMixedOrigin
        }
    }
}

#Preview {
    ExploreView()
        .modelContainer(for: [Word.self, UserProgress.self, UserSettings.self], inMemory: true)
}
