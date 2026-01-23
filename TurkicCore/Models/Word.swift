//
//  Word.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftData
import Foundation

@Model
final class Word {
    @Attribute(.unique) var id: Int
    var ru: String
    var en: String
    var pos: String
    var level: String
    var frequency: Int
    var cognateScore: Double
    var origin: String
    
    // Kazakh
    var kkNative: String
    var kkLatin: String?
    var kkIPA: String
    
    // Turkish
    var trNative: String
    var trIPA: String
    
    // Uzbek
    var uzNative: String
    var uzIPA: String
    
    // Kyrgyz
    var kyNative: String
    var kyLatin: String?
    var kyIPA: String
    
    // Tatar
    var ttNative: String
    var ttLatin: String?
    var ttIPA: String
    
    // Azerbaijani
    var azNative: String
    var azIPA: String
    
    init(id: Int, ru: String, en: String, pos: String, level: String, frequency: Int,
         cognateScore: Double, origin: String,
         kkNative: String, kkLatin: String?, kkIPA: String,
         trNative: String, trIPA: String,
         uzNative: String, uzIPA: String,
         kyNative: String, kyLatin: String?, kyIPA: String,
         ttNative: String, ttLatin: String?, ttIPA: String,
         azNative: String, azIPA: String) {
        self.id = id
        self.ru = ru
        self.en = en
        self.pos = pos
        self.level = level
        self.frequency = frequency
        self.cognateScore = cognateScore
        self.origin = origin
        
        self.kkNative = kkNative
        self.kkLatin = kkLatin
        self.kkIPA = kkIPA
        
        self.trNative = trNative
        self.trIPA = trIPA
        
        self.uzNative = uzNative
        self.uzIPA = uzIPA
        
        self.kyNative = kyNative
        self.kyLatin = kyLatin
        self.kyIPA = kyIPA
        
        self.ttNative = ttNative
        self.ttLatin = ttLatin
        self.ttIPA = ttIPA
        
        self.azNative = azNative
        self.azIPA = azIPA
    }
    
    convenience init(from json: WordJSON) {
        self.init(
            id: json.id,
            ru: json.ru,
            en: json.en,
            pos: json.pos,
            level: json.level ?? "A1",
            frequency: json.frequency,
            cognateScore: json.cognateScore,
            origin: json.origin,
            kkNative: json.forms.kk.native,
            kkLatin: json.forms.kk.latin,
            kkIPA: json.forms.kk.ipa,
            trNative: json.forms.tr.native,
            trIPA: json.forms.tr.ipa,
            uzNative: json.forms.uz.native,
            uzIPA: json.forms.uz.ipa,
            kyNative: json.forms.ky.native,
            kyLatin: json.forms.ky.latin,
            kyIPA: json.forms.ky.ipa,
            ttNative: json.forms.tt.native,
            ttLatin: json.forms.tt.latin,
            ttIPA: json.forms.tt.ipa,
            azNative: json.forms.az.native,
            azIPA: json.forms.az.ipa
        )
    }
    
    func getNative(for langCode: String) -> String {
        switch langCode {
        case "kk": return kkNative
        case "tr": return trNative
        case "uz": return uzNative
        case "ky": return kyNative
        case "tt": return ttNative
        case "az": return azNative
        default: return ""
        }
    }
    
    func getLatin(for langCode: String) -> String? {
        switch langCode {
        case "kk": return kkLatin
        case "ky": return kyLatin
        case "tt": return ttLatin
        default: return nil
        }
    }
    
    func getIPA(for langCode: String) -> String {
        switch langCode {
        case "kk": return kkIPA
        case "tr": return trIPA
        case "uz": return uzIPA
        case "ky": return kyIPA
        case "tt": return ttIPA
        case "az": return azIPA
        default: return ""
        }
    }
    
    func getTTSCode(for langCode: String) -> String {
        switch langCode {
        case "kk": return "kk-KZ"
        case "tr": return "tr-TR"
        case "uz": return "uz-UZ"
        case "ky": return "ky-KG"
        case "tt": return "tt-RU"
        case "az": return "az-AZ"
        default: return "en-US"
        }
    }
}

// MARK: - JSON Decoding Structures
struct WordsFile: Codable {
    let version: String
    let totalWords: Int
    let words: [WordJSON]
}

struct WordJSON: Codable {
    let id: Int
    let ru: String
    let en: String
    let pos: String
    let level: String?
    let frequency: Int
    let cognateScore: Double
    let origin: String
    let forms: FormsJSON
}

struct FormsJSON: Codable {
    let kk: FormJSON
    let tr: FormJSON
    let uz: FormJSON
    let ky: FormJSON
    let tt: FormJSON
    let az: FormJSON
}

struct FormJSON: Codable {
    let native: String
    let latin: String?
    let ipa: String
}
