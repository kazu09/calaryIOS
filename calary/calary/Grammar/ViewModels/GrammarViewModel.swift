//
//  GrammarViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class GrammarViewModel {
    private let repository: any GrammarRepository
    
    private(set) var notes: [GrammarNote] = []
    var errorMessage: String?
    
    init(repository: any GrammarRepository) {
        self.repository = repository
    }
    
    /// Repositoryから英文法メモ一覧を再取得
    func load() {
        do {
            notes = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 英文法メモを作成し、一覧を再取得する
    /// - Parameter value: タイトルと本文を含む入力値
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func createNote(from value: GrammarFormValue) throws {
        _ = try repository.create(from: value)
        load()
    }
}
