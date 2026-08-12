//
//  VocabularyRepository.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
protocol VocabularyRepository {
    func fetchAll() throws -> [VocabularyCard]
    func create(from value: WordFormValue, diary: Diary) throws -> VocabularyCard
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
