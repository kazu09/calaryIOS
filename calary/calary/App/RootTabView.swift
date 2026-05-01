//
//  RootTabView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image("home")
                    Text("tab.home")
                }
                
            WordView()
                .tabItem {
                    Image("card")
                    Text("tab.word")
                }
                
            GrammarView()
                .tabItem {
                    Image("book")
                    Text("tab.grammar")
                }
                
            SettingsView()
                .tabItem {
                    Image("settings")
                    Text("tab.settings")
                }
        }
    }
}

#Preview {
    RootTabView()
}
