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
    
    /// 指定されたSwiftDataコンテナからアプリの依存関係を生成する。
    /// - Parameter modelContainer: Repositoryが使用するSwiftDataコンテナ。
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
    
    /// Preview専用のインメモリDBを使用する依存関係を生成する。
    /// - Returns: Preview終了時に破棄される保存領域を持つ依存関係。
    static func preview() -> AppDependencies {
        AppDependencies(modelContainer: AppModelContainer.preview())
    }
}
