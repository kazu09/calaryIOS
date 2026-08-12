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
    
    var displayedDiaries: [Diary] {
        let calendar = Calendar.current
        return diaries.filter {
            calendar.isDate($0.entryDate, equalTo: displayedMonth, toGranularity: .month)
        }
    }
    
    func load() {
        do {
            diaries = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createDiary(from value: DiaryFormValue) throws {
        _ = try repository.create(from: value)
        displayedMonth = value.entryDate
        load()
    }
    
    func moveMonth(by value: Int) {
        guard let nextMonth = Calendar.current.date(
            byAdding: .month,
            value: value,
            to: displayedMonth
        ) else { return }
        displayedMonth = nextMonth
    }
    
    func questionStatus(for diary: Diary) -> String {
        guard diary.teacherQuestion?.isEmpty == false else { return "" }
        return diary.teacherQuestionStatus == "resolved" ? "回答済み" : "未回答"
    }
}
