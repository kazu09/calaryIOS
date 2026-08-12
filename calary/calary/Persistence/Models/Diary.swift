//
//  Diary.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

/// 1日分の英語日記と学習情報を表すモデル
@Model
final class Diary {
    @Attribute(.unique) var id: UUID
    var entryDate: Date
    var englishText: String
    var japaneseText: String
    var diaryTag: String?
    var teacherQuestion: String?
    var teacherQuestionStatus: String?
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \VocabularyCard.diary)
    var vocabularyCards: [VocabularyCard]
    
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
