//
//  VocabularyRepository.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
protocol VocabularyRepository {
    /// 保存されている単語カードを作成日の降順で取得
    /// - Returns: 作成日の新しい順に並んだ単語カード
    func fetchAll() throws -> [VocabularyCard]

    /// 保存済みの日記へ単語カードを追加
    /// - Parameters:
    ///   - value: 英単語と複数の意味・品詞を含む入力値
    ///   - diary: 単語カードの登録元となる日記
    /// - Returns: 保存された単語カード
    func create(from value: WordFormValue, diary: Diary) throws -> VocabularyCard

    /// 既存の単語カードと意味一覧を入力内容で置き換える
    /// - Parameters:
    ///   - card: 更新対象の単語カード
    ///   - value: 編集後の英単語と意味・品詞
    func update(_ card: VocabularyCard, from value: WordFormValue) throws
}

@MainActor
final class SwiftDataVocabularyRepository: VocabularyRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [VocabularyCard] {
        let descriptor = FetchDescriptor<VocabularyCard>(
            sortBy: [SortDescriptor(\VocabularyCard.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func create(
        from value: WordFormValue,
        diary: Diary
    ) throws -> VocabularyCard {
        let card = VocabularyCard(
            word: value.word,
            displayOrder: diary.vocabularyCards.count,
            diary: diary
        )
        modelContext.insert(card)
        insertMeanings(from: value, into: card)
        try modelContext.saveWithLog(
            action: .create,
            entity: "VocabularyCard",
            id: card.id,
            details: logDetails(for: value, diaryID: diary.id)
        )
        return card
    }

    func update(_ card: VocabularyCard, from value: WordFormValue) throws {
        card.word = value.word
        card.updatedAt = .now

        let previousMeanings = card.meanings
        card.meanings.removeAll()
        for meaning in previousMeanings {
            modelContext.delete(meaning)
        }
        insertMeanings(from: value, into: card)

        try modelContext.saveWithLog(
            action: .update,
            entity: "VocabularyCard",
            id: card.id,
            details: logDetails(for: value, diaryID: card.diary?.id)
        )
    }

    private func insertMeanings(
        from value: WordFormValue,
        into card: VocabularyCard
    ) {
        for (index, entry) in value.entries.enumerated() {
            let meaning = VocabularyMeaning(
                japaneseMeaning: entry.japaneseMeaning,
                partOfSpeech: entry.partOfSpeech,
                displayOrder: index
            )
            modelContext.insert(meaning)
            card.meanings.append(meaning)
        }
    }

    private func logDetails(
        for value: WordFormValue,
        diaryID: UUID?
    ) -> String {
        let meanings = value.entries.enumerated().map { index, entry in
            "{order=\(index), meaning=\(PersistenceLogValue.string(entry.japaneseMeaning)), partOfSpeech=\(PersistenceLogValue.string(entry.partOfSpeech))}"
        }
        .joined(separator: ", ")

        return "word=\(PersistenceLogValue.string(value.word)) diaryID=\(PersistenceLogValue.string(diaryID?.uuidString)) meanings=[\(meanings)]"
    }
}
