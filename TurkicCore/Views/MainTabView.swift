//
//  MainTabView.swift
//  TurkicCore
//
//  Created for turkic.core project
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @AppStorage("interfaceLanguage") private var interfaceLanguage = "ru"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label(
                        interfaceLanguage == "ru" ? "Сегодня" : "Today",
                        systemImage: "house.fill"
                    )
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Label(
                        interfaceLanguage == "ru" ? "Словарь" : "Dictionary",
                        systemImage: "books.vertical.fill"
                    )
                }
                .tag(1)
            
            ProgressTabView()
                .tabItem {
                    Label(
                        interfaceLanguage == "ru" ? "Прогресс" : "Progress",
                        systemImage: "chart.bar.fill"
                    )
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label(
                        interfaceLanguage == "ru" ? "Настройки" : "Settings",
                        systemImage: "gearshape.fill"
                    )
                }
                .tag(3)
        }
        .tint(Color.tcPrimary)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Word.self, UserProgress.self, UserSettings.self], inMemory: true)
}
