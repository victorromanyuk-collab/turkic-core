//
//  SpacedRepetitionManager.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftData
import Foundation

struct SpacedRepetitionManager {
    
    /// Get words for a learning session
    static func getWordsForSession(
        context: ModelContext,
        newCount: Int = 5,
        reviewCount: Int = 10
    ) -> [Word] {
        var result: [Word] = []
        
        // 1. Get due reviews (highest priority)
        let now = Date()
        let dueDescriptor = FetchDescriptor<UserProgress>(
            predicate: #Predicate<UserProgress> { progress in
                progress.nextReviewDate <= now && progress.statusRaw != "mastered"
            },
            sortBy: [SortDescriptor(\.nextReviewDate)]
        )
        
        if let dueProgress = try? context.fetch(dueDescriptor) {
            let dueWordIds = dueProgress.prefix(reviewCount).map { $0.wordId }
            
            for id in dueWordIds {
                if let word = getWord(byId: id, context: context) {
                    result.append(word)
                }
            }
        }
        
        // 2. Get new words (if we have room)
        if result.count < reviewCount + newCount {
            let remainingSlots = (reviewCount + newCount) - result.count
            let newWords = getNewWords(context: context, limit: max(newCount, remainingSlots))
            result.append(contentsOf: newWords)
        }
        
        // 3. Shuffle for variety (interleaving)
        return result.shuffled()
    }
    
    /// Get new words that haven't been studied yet
    private static func getNewWords(context: ModelContext, limit: Int) -> [Word] {
        // Get all learned word IDs
        let allProgressDescriptor = FetchDescriptor<UserProgress>()
        let learnedIds = (try? context.fetch(allProgressDescriptor))?.map { $0.wordId } ?? []
        
        // Fetch all words sorted by frequency
        let newDescriptor = FetchDescriptor<Word>(
            sortBy: [SortDescriptor(\.frequency)]
        )
        
        if let allWords = try? context.fetch(newDescriptor) {
            let newWords = allWords.filter { !learnedIds.contains($0.id) }
            return Array(newWords.prefix(limit))
        }
        
        return []
    }
    
    /// Get a word by ID
    private static func getWord(byId id: Int, context: ModelContext) -> Word? {
        let descriptor = FetchDescriptor<Word>(
            predicate: #Predicate<Word> { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }
    
    /// Record an answer for a word
    static func recordAnswer(
        context: ModelContext,
        wordId: Int,
        correct: Bool
    ) {
        let descriptor = FetchDescriptor<UserProgress>(
            predicate: #Predicate<UserProgress> { $0.wordId == wordId }
        )
        
        let progress: UserProgress
        
        if let existing = try? context.fetch(descriptor).first {
            progress = existing
        } else {
            progress = UserProgress(wordId: wordId)
            context.insert(progress)
        }
        
        progress.recordAnswer(correct: correct)
        
        do {
            try context.save()
        } catch {
            print("Error saving progress: \(error)")
        }
    }
    
    /// Get statistics for the user's progress
    static func getStatistics(context: ModelContext) -> ProgressStatistics {
        let allProgressDescriptor = FetchDescriptor<UserProgress>()
        guard let allProgress = try? context.fetch(allProgressDescriptor) else {
            return ProgressStatistics()
        }
        
        let newCount = allProgress.filter { $0.status == .new }.count
        let learning = allProgress.filter { $0.status == .learning }.count
        let reviewing = allProgress.filter { $0.status == .reviewing }.count
        let mastered = allProgress.filter { $0.status == .mastered }.count
        let dueCount = allProgress.filter { $0.isDue }.count
        
        let totalCorrect = allProgress.reduce(0) { $0 + $1.correctCount }
        let totalIncorrect = allProgress.reduce(0) { $0 + $1.incorrectCount }
        let totalReviews = totalCorrect + totalIncorrect
        let accuracy = totalReviews > 0 ? Double(totalCorrect) / Double(totalReviews) : 0.0
        
        return ProgressStatistics(
            newWords: newCount,
            learningWords: learning,
            reviewingWords: reviewing,
            masteredWords: mastered,
            dueForReview: dueCount,
            totalReviews: totalReviews,
            accuracy: accuracy
        )
    }
}

struct ProgressStatistics {
    var newWords: Int = 0
    var learningWords: Int = 0
    var reviewingWords: Int = 0
    var masteredWords: Int = 0
    var dueForReview: Int = 0
    var totalReviews: Int = 0
    var accuracy: Double = 0.0
    
    var totalStudied: Int {
        learningWords + reviewingWords + masteredWords
    }
}
