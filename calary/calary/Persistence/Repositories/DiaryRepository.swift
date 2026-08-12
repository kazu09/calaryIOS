//
//  DiaryRepository.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
protocol DiaryRepository {
    func fetchAll() throws -> [Diary]
    func create(from value: DiaryFormValue) throws -> Diary
    func update(_ diary: Diary, from value: DiaryFormValue) throws
    func delete(_ diary: Diary) throws
    func toggleQuestionStatus(for diary: Diary) throws
}

@MainActor
final class SwiftDataDiaryRepository: DiaryRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [Diary] {
        let descriptor = FetchDescriptor<Diary>(
            sortBy: [SortDescriptor(\Diary.entryDate, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func create(from value: DiaryFormValue) throws -> Diary {
        let question = value.teacherQuestion.isEmpty ? nil : value.teacherQuestion
        let diary = Diary(
            entryDate: value.entryDate,
            englishText: value.englishText,
            japaneseText: value.japaneseText,
            diaryTag: value.diaryTag,
            teacherQuestion: question,
            teacherQuestionStatus: question == nil ? nil : "open"
        )
        modelContext.insert(diary)
        try modelContext.saveWithLog(
            action: .create,
            entity: "Diary",
            id: diary.id,
            details: logDetails(for: diary)
        )
        return diary
    }

    func update(_ diary: Diary, from value: DiaryFormValue) throws {
        let question = value.teacherQuestion.isEmpty ? nil : value.teacherQuestion
        diary.entryDate = value.entryDate
        diary.englishText = value.englishText
        diary.japaneseText = value.japaneseText
        diary.diaryTag = value.diaryTag
        diary.teacherQuestion = question
        diary.teacherQuestionStatus = question == nil
            ? nil
            : diary.teacherQuestionStatus ?? "open"
        diary.updatedAt = .now
        try modelContext.saveWithLog(
            action: .update,
            entity: "Diary",
            id: diary.id,
            details: logDetails(for: diary)
        )
    }

    func delete(_ diary: Diary) throws {
        let id = diary.id
        let details = logDetails(for: diary)
        modelContext.delete(diary)
        try modelContext.saveWithLog(
            action: .delete,
            entity: "Diary",
            id: id,
            details: details
        )
    }

    func toggleQuestionStatus(for diary: Diary) throws {
        diary.teacherQuestionStatus = diary.teacherQuestionStatus == "resolved"
            ? "open"
            : "resolved"
        diary.updatedAt = .now
        try modelContext.saveWithLog(
            action: .update,
            entity: "Diary",
            id: diary.id,
            details: logDetails(for: diary)
        )
    }

    private func logDetails(for diary: Diary) -> String {
        "entryDate=\(diary.entryDate.ISO8601Format()) englishText=\(PersistenceLogValue.string(diary.englishText)) japaneseText=\(PersistenceLogValue.string(diary.japaneseText)) diaryTag=\(PersistenceLogValue.string(diary.diaryTag)) teacherQuestion=\(PersistenceLogValue.string(diary.teacherQuestion)) questionStatus=\(PersistenceLogValue.string(diary.teacherQuestionStatus)) vocabularyCount=\(diary.vocabularyCards.count)"
    }
}
