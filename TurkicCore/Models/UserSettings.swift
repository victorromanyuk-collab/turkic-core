//
//  UserSettings.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftData
import Foundation

@Model
final class UserSettings {
    var interfaceLanguage: String = "ru"
    var activeLanguagesRaw: String = "kk,tr,uz"
    var dailyGoalMinutes: Int = 15
    var soundEnabled: Bool = true
    var hapticEnabled: Bool = true
    var currentStreak: Int = 0
    var lastSessionDate: Date?
    var totalStudyTimeMinutes: Int = 0
    var createdAt: Date = Date()
    
    var activeLanguages: [String] {
        get { activeLanguagesRaw.split(separator: ",").map(String.init) }
        set { activeLanguagesRaw = newValue.joined(separator: ",") }
    }
    
    init() {
        self.createdAt = Date()
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastSession = lastSessionDate {
            let lastSessionDay = calendar.startOfDay(for: lastSession)
            let daysDifference = calendar.dateComponents([.day], from: lastSessionDay, to: today).day ?? 0
            
            if daysDifference == 0 {
                return
            } else if daysDifference == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        lastSessionDate = Date()
    }
    
    func addStudyTime(minutes: Int) {
        totalStudyTimeMinutes += minutes
        updateStreak()
    }
    
    func toggleLanguage(_ code: String) {
        var langs = activeLanguages
        if langs.contains(code) {
            langs.removeAll { $0 == code }
        } else {
            langs.append(code)
        }
        activeLanguages = langs
    }
    
    func isLanguageActive(_ code: String) -> Bool {
        return activeLanguages.contains(code)
    }
}
