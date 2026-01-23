//
//  SimilarityEngine.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import Foundation

/// Engine for calculating similarity between Turkic language words
struct SimilarityEngine {
    
    /// Calculate Levenshtein distance between two strings
    static func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let len1 = s1.count
        let len2 = s2.count
        
        if len1 == 0 { return len2 }
        if len2 == 0 { return len1 }
        
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: len2 + 1), count: len1 + 1)
        
        for i in 0...len1 {
            matrix[i][0] = i
        }
        
        for j in 0...len2 {
            matrix[0][j] = j
        }
        
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        
        for i in 1...len1 {
            for j in 1...len2 {
                if s1Array[i-1] == s2Array[j-1] {
                    matrix[i][j] = matrix[i-1][j-1]
                } else {
                    matrix[i][j] = min(
                        matrix[i-1][j] + 1,
                        matrix[i][j-1] + 1,
                        matrix[i-1][j-1] + 1
                    )
                }
            }
        }
        
        return matrix[len1][len2]
    }
    
    /// Calculate similarity score (0.0 to 1.0) between two words
    static func similarityScore(_ word1: String, _ word2: String) -> Double {
        let maxLen = Double(max(word1.count, word2.count))
        guard maxLen > 0 else { return 1.0 }
        
        let distance = Double(levenshteinDistance(word1, word2))
        return 1.0 - (distance / maxLen)
    }
    
    /// Calculate average cognate score across all forms of a word
    static func calculateCognateScore(forms: [String]) -> Double {
        guard forms.count > 1 else { return 1.0 }
        
        var totalSimilarity = 0.0
        var comparisons = 0
        
        for i in 0..<forms.count {
            for j in (i+1)..<forms.count {
                totalSimilarity += similarityScore(forms[i], forms[j])
                comparisons += 1
            }
        }
        
        return comparisons > 0 ? totalSimilarity / Double(comparisons) : 0.0
    }
    
    /// Get color hex for cognate score visualization
    static func colorHexForScore(_ score: Double) -> String {
        if score >= 0.8 {
            return "#16A085"
        } else if score >= 0.5 {
            return "#F39C12"
        } else {
            return "#E74C3C"
        }
    }
}
