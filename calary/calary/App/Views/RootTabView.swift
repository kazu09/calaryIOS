//
//  RootTabView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct RootTabView: View {
    let dependencies: AppDependencies
    
    var body: some View {
        TabView {
            HomeView(
                diaryRepository: dependencies.diaryRepository,
                vocabularyRepository: dependencies.vocabularyRepository
            )
            .tabItem {
                Image("home")
                Text("tab.home")
            }
            
            WordView(repository: dependencies.vocabularyRepository)
                .tabItem {
                    Image("card")
                    Text("tab.word")
                }
            
            GrammarView(repository: dependencies.grammarRepository)
                .tabItem {
                    Image("book")
                    Text("tab.grammar")
                }
            
            SettingsView(dependencies: dependencies)
                .tabItem {
                    Image("settings")
                    Text("tab.settings")
                }
        }
    }
}

#Preview {
    RootTabView(dependencies: .preview())
}
