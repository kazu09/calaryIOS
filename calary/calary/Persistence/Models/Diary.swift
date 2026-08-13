//
//  Diary.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Diary {
    /// 日記を一意に識別するID
    @Attribute(.unique) var id: UUID
    /// 日記の学習日
    var entryDate: Date
    /// 英語の日記本文
    var englishText: String
    /// 日本語の日記本文
    var japaneseText: String
    /// 日記へ設定したタグ名
    var diaryTag: String?
    /// 先生へ確認したい質問
    var teacherQuestion: String?
    /// 質問の状態。未回答は`open`、回答済みは`resolved`
    var teacherQuestionStatus: String?
    /// 作成日時
    var createdAt: Date
    /// 最終更新日時
    var updatedAt: Date
    
    /// 日記から登録した単語カード。日記の削除時に同時に削除される
    @Relationship(deleteRule: .cascade, inverse: \VocabularyCard.diary)
    var vocabularyCards: [VocabularyCard]
    
    /// 日記に関連付けられた英文法メモ。日記の削除時は関連だけが解除される。
    @Relationship(deleteRule: .nullify, inverse: \GrammarNote.diary)
    var grammarNotes: [GrammarNote]
    
    /// 日記を生成する。
    /// - Parameters:
    ///   - id: 日記を一意に識別するID
    ///   - entryDate: 日記の学習日
    ///   - englishText: 英語の日記本文
    ///   - japaneseText: 日本語の日記本文
    ///   - diaryTag: 日記に設定するタグ名
    ///   - teacherQuestion: 先生へ確認したい質問
    ///   - teacherQuestionStatus: 質問の状態。`open`または`resolved`
    ///   - createdAt: 作成日時
    ///   - updatedAt: 最終更新日時
    init(
        id: UUID = UUID(),
        entryDate: Date,
        englishText: String,
        japaneseText: String,
        diaryTag: String? = nil,
        teacherQuestion: String? = nil,
        teacherQuestionStatus: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.entryDate = entryDate
        self.englishText = englishText
        self.japaneseText = japaneseText
        self.diaryTag = diaryTag
        self.teacherQuestion = teacherQuestion
        self.teacherQuestionStatus = teacherQuestionStatus
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        vocabularyCards = []
        grammarNotes = []
    }
}
