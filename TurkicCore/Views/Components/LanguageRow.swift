//
//  LanguageRow.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct LanguageRow: View {
    let flag: String
    let name: String
    let native: String
    let latin: String?
    let ipa: String
    let ttsCode: String
    
    @StateObject private var ttsManager = TTSManager.shared
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(flag)
                    .font(.title2)
                
                Text(name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if soundEnabled {
                    Button(action: speak) {
                        Image(systemName: ttsManager.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                            .foregroundStyle(Color.tcPrimary)
                            .font(.title3)
                    }
                }
            }
            
            Text(native)
                .font(.system(size: 32, weight: .semibold))
            
            if let latin = latin, !latin.isEmpty {
                Text(latin)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Text(ipa)
                .font(.body)
                .foregroundStyle(.secondary)
                .italic()
        }
        .padding()
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func speak() {
        if hapticEnabled {
            HapticManager.light()
        }
        ttsManager.speak(native, language: ttsCode)
    }
}

#Preview {
    LanguageRow(
        flag: "🇰🇿",
        name: "Kazakh",
        native: "су",
        latin: "su",
        ipa: "[su]",
        ttsCode: "kk-KZ"
    )
    .padding()
}
