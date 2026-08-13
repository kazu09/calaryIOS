//
//  GrammarRepository.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
protocol GrammarRepository {
    /// 保存されている英文法メモを更新日の降順で取得
    /// - Returns: 更新日の新しい順に並んだ英文法メモ
    func fetchAll() throws -> [GrammarNote]

    /// 入力内容から英文法メモを作成して保存する
    /// - Parameter value: タイトルと本文を含む入力値
    /// - Returns: 保存された英文法メモ
    func create(from value: GrammarFormValue) throws -> GrammarNote

    /// 既存の英文法メモを入力内容で更新して保存
    /// - Parameters:
    ///   - note: 更新対象の英文法メモ
    ///   - value: 編集後のタイトルと本文
    func update(_ note: GrammarNote, from value: GrammarFormValue) throws

    /// 英文法メモを削除
    /// - Parameter note: 削除対象の英文法メモ
    func delete(_ note: GrammarNote) throws
}

@MainActor
final class SwiftDataGrammarRepository: GrammarRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [GrammarNote] {
        let descriptor = FetchDescriptor<GrammarNote>(
            sortBy: [SortDescriptor(\GrammarNote.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func create(from value: GrammarFormValue) throws -> GrammarNote {
        let note = GrammarNote(title: value.title, content: value.content)
        modelContext.insert(note)
        try modelContext.saveWithLog(
            action: .create,
            entity: "GrammarNote",
            id: note.id,
            details: logDetails(for: note)
        )
        return note
    }

    func update(_ note: GrammarNote, from value: GrammarFormValue) throws {
        note.title = value.title
        note.content = value.content
        note.updatedAt = .now
        try modelContext.saveWithLog(
            action: .update,
            entity: "GrammarNote",
            id: note.id,
            details: logDetails(for: note)
        )
    }

    func delete(_ note: GrammarNote) throws {
        let id = note.id
        let details = logDetails(for: note)
        modelContext.delete(note)
        try modelContext.saveWithLog(
            action: .delete,
            entity: "GrammarNote",
            id: id,
            details: details
        )
    }

    private func logDetails(for note: GrammarNote) -> String {
        "title=\(PersistenceLogValue.string(note.title)) content=\(PersistenceLogValue.string(note.content)) diaryID=\(PersistenceLogValue.string(note.diary?.id.uuidString)) updatedAt=\(note.updatedAt.ISO8601Format())"
    }
}
