//
//  DiaryRepository.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
protocol DiaryRepository {
    /// 保存されている日記を学習日の降順で取得する
    /// - Returns: 学習日の新しい順に並んだ日記
    func fetchAll() throws -> [Diary]

    /// 入力内容から日記を作成して保存する
    /// - Parameter value: 日記作成画面で入力された値
    /// - Returns: 保存された日記。
    func create(from value: DiaryFormValue) throws -> Diary

    /// 既存の日記を入力内容で更新して保存する
    /// - Parameters:
    ///   - diary: 更新対象の日記
    ///   - value: 日記編集画面で入力された値
    func update(_ diary: Diary, from value: DiaryFormValue) throws

    /// 日記を削除する。
    ///
    /// 日記に属する単語カードはSwiftDataのcascade設定により同時に削除される
    /// - Parameter diary: 削除対象の日記
    func delete(_ diary: Diary) throws

    /// 先生への質問状態を`open`と`resolved`の間で切り替える
    /// - Parameter diary: 質問状態を変更する日記
    func toggleQuestionStatus(for diary: Diary) throws
}

/// `DiaryRepository`をSwiftDataで実装するRepository
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
