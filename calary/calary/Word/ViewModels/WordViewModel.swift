//
//  WordViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class WordViewModel {
    private let repository: any VocabularyRepository
    
    private(set) var cards: [VocabularyCard] = []
    var errorMessage: String?
    
    init(repository: any VocabularyRepository) {
        self.repository = repository
    }
    
    /// Repositoryから単語カード一覧を再取得する
    func load() {
        do {
            cards = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 単語カードの登録元となる日記の日付を表示用文字列へ変換する
    /// - Parameter card: 登録元を確認する単語カード
    /// - Returns: 日記の日付、または登録元がないことを示す文字列
    func diaryDate(for card: VocabularyCard) -> String {
        guard let date = card.diary?.entryDate else {
            return String(localized: "word.source_diary.none")
        }
        return String(
            localized: "word.source_diary.date \(date.formatted(date: .numeric, time: .omitted))"
        )
    }
}
