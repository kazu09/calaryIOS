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
    
    /// 日記編集画面へ渡す現在値
    var formValue: DiaryFormValue {
        DiaryFormValue(
            entryDate: diary.entryDate,
            englishText: diary.englishText,
            japaneseText: diary.japaneseText,
            diaryTag: diary.diaryTag,
            teacherQuestion: diary.teacherQuestion ?? ""
        )
    }
    
    /// 先生への質問が存在する場合に表示する回答状態
    var questionStatus: String? {
        guard diary.teacherQuestion?.isEmpty == false else { return nil }
        return diary.teacherQuestionStatus == "resolved"
            ? String(localized: "diary.question.status.answered")
            : String(localized: "diary.question.status.unanswered")
    }
    
    /// 日記を編集画面の入力内容で更新する
    /// - Parameter value: 編集後の日記入力値
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func updateDiary(from value: DiaryFormValue) throws {
        try diaryRepository.update(diary, from: value)
        errorMessage = nil
    }
    
    /// 表示中の日記へ単語カードを追加する
    /// - Parameter value: 英単語と意味・品詞を含む入力値
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func addWord(from value: WordFormValue) throws {
        _ = try vocabularyRepository.create(from: value, diary: diary)
        errorMessage = nil
    }
    
    /// 先生への質問状態を切り替える
    func toggleQuestionStatus() {
        perform {
            try diaryRepository.toggleQuestionStatus(for: diary)
        }
    }
    
    /// 表示中の日記を削除する
    /// - Returns: 削除に成功した場合は`true`、失敗した場合は`false`
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
