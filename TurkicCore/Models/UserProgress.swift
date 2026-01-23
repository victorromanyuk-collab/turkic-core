//
//  UserProgress.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftData
import Foundation

@Model
final class UserProgress {
    @Attribute(.unique) var wordId: Int
    
    // SM-2 Algorithm parameters
    var easeFactor: Double = 2.5
    var interval: Int = 1
    var repetitions: Int = 0
    var nextReviewDate: Date = Date()
    
    // Statistics
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var lastReviewedAt: Date?
    var firstSeenAt: Date = Date()
    
    var statusRaw: String = "new"
    
    var status: LearningStatus {
        get { LearningStatus(rawValue: statusRaw) ?? .new }
        set { statusRaw = newValue.rawValue }
    }
    
    enum LearningStatus: String, Codable {
        case new
        case learning
        case reviewing
        case mastered
    }
    
    init(wordId: Int) {
        self.wordId = wordId
        self.firstSeenAt = Date()
    }
    
    /// Record an answer using the SM-2 spaced repetition algorithm
    func recordAnswer(correct: Bool) {
        lastReviewedAt = Date()
        
        if correct {
            correctCount += 1
            
            // SM-2 algorithm
            if repetitions == 0 {
                interval = 1
            } else if repetitions == 1 {
                interval = 6
            } else {
                interval = Int(Double(interval) * easeFactor)
            }
            
            repetitions += 1
            easeFactor = max(1.3, easeFactor + 0.1)
            
        } else {
            incorrectCount += 1
            repetitions = 0
            interval = 1
            easeFactor = max(1.3, easeFactor - 0.2)
        }
        
        // Calculate next review date
        nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: interval,
            to: Date()
        ) ?? Date()
        
        // Update learning status
        updateStatus()
    }
    
    private func updateStatus() {
        if repetitions >= 5 && easeFactor >= 2.5 {
            status = .mastered
        } else if repetitions > 0 {
            status = .reviewing
        } else if correctCount > 0 || incorrectCount > 0 {
            status = .learning
        } else {
            status = .new
        }
    }
    
    var accuracy: Double {
        let total = correctCount + incorrectCount
        guard total > 0 else { return 0.0 }
        return Double(correctCount) / Double(total)
    }
    
    var isDue: Bool {
        return nextReviewDate <= Date() && status != .mastered
    }
}
