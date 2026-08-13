//
//  AppModelContainer.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

enum AppModelContainer {
    /// 通常起動時に使用する永続化された共通コンテナ。
    static let shared = makeContainer()
    
    /// 現在のプロセスがXcode Previewとして起動しているかを示す。
    static var isRunningForPreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    /// 実行環境に応じたアプリ用コンテナを返す
    ///
    /// Previewでは実データを変更しないようインメモリDBを使用する
    static func application() -> ModelContainer {
        isRunningForPreviews ? preview() : shared
    }
    
    /// ディスクへ保存しないPreview専用コンテナを生成する
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
