//
//  GrammarNote.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class GrammarNote {
    /// 英文法メモを一意に識別するID
    @Attribute(.unique) var id: UUID
    /// 画面へ表示するタイトル
    var title: String
    /// 文法の説明や例文を記録する本文
    var content: String
    /// 作成日時
    var createdAt: Date
    /// 最終更新日時
    var updatedAt: Date
    /// 関連する日記。MVPでは英文法メモを単独で扱うため通常は`nil`
    var diary: Diary?
    
    /// 英文法メモを生成する。
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
