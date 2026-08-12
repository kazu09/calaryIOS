//
//  calaryApp.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct calaryApp: App {
    private let modelContainer: ModelContainer
    private let dependencies: AppDependencies

    init() {
        let modelContainer = AppModelContainer.application()
        self.modelContainer = modelContainer
        dependencies = AppDependencies(modelContainer: modelContainer)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            RootTabView(dependencies: dependencies)
        }
        .modelContainer(modelContainer)
    }
}
