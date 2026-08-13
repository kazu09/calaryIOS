//
//  VocabularyMeaning.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class VocabularyMeaning {
    /// 単語の意味を一意に識別するID
    @Attribute(.unique) var id: UUID
    /// 英単語に対する日本語訳
    var japaneseMeaning: String
    /// この日本語訳に対応する品詞
    var partOfSpeech: String?
    /// 同じ単語カードに登録された意味の中での表示順
    var displayOrder: Int
    /// 作成日時
    var createdAt: Date
    /// 最終更新日時
    var updatedAt: Date
    /// この意味を所有する単語カード
    var card: VocabularyCard?
    
    /// 単語の意味を生成する
    /// - Parameters:
    ///   - id: 意味を一意に識別するID
    ///   - japaneseMeaning: 日本語訳
    ///   - partOfSpeech: この意味に対応する品詞
    ///   - displayOrder: 同じ単語カード内での表示順
    ///   - card: この意味が属する単語カード
    ///   - createdAt: 作成日時
    ///   - updatedAt: 最終更新日時
    init(
        id: UUID = UUID(),
        japaneseMeaning: String,
        partOfSpeech: String? = nil,
        displayOrder: Int,
        card: VocabularyCard? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.japaneseMeaning = japaneseMeaning
        self.partOfSpeech = partOfSpeech
        self.displayOrder = displayOrder
        self.card = card
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
