//
//  HomeViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private let repository: any DiaryRepository
    
    private(set) var diaries: [Diary] = []
    var displayedMonth = Date()
    var errorMessage: String?
    
    init(repository: any DiaryRepository) {
        self.repository = repository
    }
    
    /// 現在選択している月に該当する日記
    var displayedDiaries: [Diary] {
        let calendar = Calendar.current
        return diaries.filter {
            calendar.isDate($0.entryDate, equalTo: displayedMonth, toGranularity: .month)
        }
    }
    
    /// Repositoryから日記一覧を再取得する
    func load() {
        do {
            diaries = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 日記を保存し、保存した日記の月をホーム画面へ表示する
    /// - Parameter value: 日記作成画面で入力された値
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func createDiary(from value: DiaryFormValue) throws {
        _ = try repository.create(from: value)
        displayedMonth = value.entryDate
        load()
    }
    
    /// 表示対象の月を指定月数だけ移動する
    /// - Parameter value: 移動する月数。前月は`-1`、翌月は`1`
    func moveMonth(by value: Int) {
        guard let nextMonth = Calendar.current.date(
            byAdding: .month,
            value: value,
            to: displayedMonth
        ) else { return }
        displayedMonth = nextMonth
    }
    
    /// 日記カードへ表示する先生への質問状態を返す
    /// - Parameter diary: 状態を確認する日記
    /// - Returns: `回答済み`、`未回答`、または質問がない場合は空文字
    func questionStatus(for diary: Diary) -> String {
        guard diary.teacherQuestion?.isEmpty == false else { return "" }
        return diary.teacherQuestionStatus == "resolved"
            ? String(localized: "diary.question.status.answered")
            : String(localized: "diary.question.status.unanswered")
    }
}
