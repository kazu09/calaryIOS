//
//  DiaryDetailViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class DiaryDetailViewModel {
    let diary: Diary
    var errorMessage: String?
    
    private let diaryRepository: any DiaryRepository
    private let vocabularyRepository: any VocabularyRepository
    
    init(
        diary: Diary,
        diaryRepository: any DiaryRepository,
        vocabularyRepository: any VocabularyRepository
    ) {
        self.diary = diary
        self.diaryRepository = diaryRepository
        self.vocabularyRepository = vocabularyRepository
    }
    
    var formValue: DiaryFormValue {
        DiaryFormValue(
            entryDate: diary.entryDate,
            englishText: diary.englishText,
            japaneseText: diary.japaneseText,
            diaryTag: diary.diaryTag,
            teacherQuestion: diary.teacherQuestion ?? ""
        )
    }
    
    var questionStatus: String? {
        guard diary.teacherQuestion?.isEmpty == false else { return nil }
        return diary.teacherQuestionStatus == "resolved" ? "回答済み" : "未回答"
    }
    
    func updateDiary(from value: DiaryFormValue) throws {
        try diaryRepository.update(diary, from: value)
        errorMessage = nil
    }
    
    func addWord(from value: WordFormValue) throws {
        _ = try vocabularyRepository.create(from: value, diary: diary)
        errorMessage = nil
    }
    
    func toggleQuestionStatus() {
        perform {
            try diaryRepository.toggleQuestionStatus(for: diary)
        }
    }
    
    func deleteDiary() -> Bool {
        do {
            try diaryRepository.delete(diary)
            errorMessage = nil
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    private func perform(_ operation: () throws -> Void) {
        do {
            try operation()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
