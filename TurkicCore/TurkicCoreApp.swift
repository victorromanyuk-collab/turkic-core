//
//  TurkicCoreApp.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI
import SwiftData

@main
struct TurkicCoreApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Word.self,
            UserProgress.self,
            UserSettings.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                    loadInitialData()
                    setupUserSettings()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func loadInitialData() {
        let context = sharedModelContainer.mainContext
        
        let descriptor = FetchDescriptor<Word>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        
        if existingCount == 0 {
            print("Loading initial word data...")
            if let url = Bundle.main.url(forResource: "words", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let json = try? JSONDecoder().decode(WordsFile.self, from: data) {
                for wordJSON in json.words {
                    let word = Word(from: wordJSON)
                    context.insert(word)
                }
                try? context.save()
                print("Loaded \(json.words.count) words")
            } else {
                print("Error: Could not load words.json")
            }
        }
    }
    
    private func setupUserSettings() {
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<UserSettings>()
        
        if (try? context.fetchCount(descriptor)) == 0 {
            let settings = UserSettings()
            context.insert(settings)
            try? context.save()
            print("Created default user settings")
        }
    }
}
