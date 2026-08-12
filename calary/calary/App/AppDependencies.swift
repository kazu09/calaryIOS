//
//  AppDependencies.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftData

@MainActor
struct AppDependencies {
    private let modelContainer: ModelContainer
    let diaryRepository: any DiaryRepository
    let vocabularyRepository: any VocabularyRepository
    let grammarRepository: any GrammarRepository
#if DEBUG
    let debugDatabaseService: any DebugDatabaseService
#endif
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = modelContainer.mainContext
        diaryRepository = SwiftDataDiaryRepository(modelContext: context)
        vocabularyRepository = SwiftDataVocabularyRepository(modelContext: context)
        grammarRepository = SwiftDataGrammarRepository(modelContext: context)
#if DEBUG
        debugDatabaseService = SwiftDataDebugDatabaseService(modelContext: context)
#endif
    }
    
    static func preview() -> AppDependencies {
        AppDependencies(modelContainer: AppModelContainer.preview())
    }
}
