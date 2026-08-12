//
//  GrammarNote.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

/// 英文法メモを保持するテーブル
@Model
final class GrammarNote {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var diary: Diary?
    
    /// 英文法メモを保持する
    /// - Parameters:
    ///   - id: 文法を一意に識別するID
    ///   - title: タイトル
    ///   - content: 本文
    ///   - diary: 日記情報
    ///   - createdAt: 作成日時
    ///   - updatedAt: 最終更新日時
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        diary: Diary? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.diary = diary
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
