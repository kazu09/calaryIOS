//
//  VocabularyCard.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class VocabularyCard {
    /// 単語カードを一意に識別するID
    @Attribute(.unique) var id: UUID
    /// 英単語の見出し
    var word: String
    /// 同じ日記に登録された単語カード内での表示順
    var displayOrder: Int
    /// 作成日時
    var createdAt: Date
    /// 最終更新日時
    var updatedAt: Date
    /// この単語を登録した日記
    var diary: Diary?
    /// この単語に登録された意味。単語カードの削除時に同時に削除される
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
