//
//  AppModelContainer.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

enum AppModelContainer {
    static let shared = makeContainer()
    
    static var isRunningForPreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static func application() -> ModelContainer {
        isRunningForPreviews ? preview() : shared
    }
    
    static func preview() -> ModelContainer {
        makeContainer(isStoredInMemoryOnly: true)
    }
    
    private static func makeContainer(
        isStoredInMemoryOnly: Bool = false
    ) -> ModelContainer {
        let schema = Schema([
            Diary.self,
            VocabularyCard.self,
            VocabularyMeaning.self,
            GrammarNote.self,
            Tag.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}
