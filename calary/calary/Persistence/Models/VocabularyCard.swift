//
//  VocabularyCard.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

/// 日記から登録した英単語の見出しを保持するテーブル
@Model
final class VocabularyCard {
    @Attribute(.unique) var id: UUID
    var word: String
    var displayOrder: Int
    var createdAt: Date
    var updatedAt: Date
    var diary: Diary?
    @Relationship(deleteRule: .cascade, inverse: \VocabularyMeaning.card)
    var meanings: [VocabularyMeaning]
    
    /// 英単語の見出しを生成する
    /// - Parameters:
    ///   - id: 単語カードを一意に識別するID
    ///   - word: 英単語の見出し
    ///   - displayOrder: 日記内表示順
    ///   - diary: 日記情報
    ///   - createdAt: 作成日時
    ///   - updatedAt: 最終更新日時
    init(
        id: UUID = UUID(),
        word: String,
        displayOrder: Int = 0,
        diary: Diary? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.word = word
        self.displayOrder = displayOrder
        self.diary = diary
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        meanings = []
    }
}
