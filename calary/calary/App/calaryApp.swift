//
//  calaryApp.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

@main
struct calaryApp: App {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
