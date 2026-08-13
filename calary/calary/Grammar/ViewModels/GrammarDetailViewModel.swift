//
//  GrammarDetailViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class GrammarDetailViewModel {
    let note: GrammarNote
    var errorMessage: String?
    
    private let repository: any GrammarRepository
    
    init(note: GrammarNote, repository: any GrammarRepository) {
        self.note = note
        self.repository = repository
    }
    
    /// 英文法メモを編集内容で更新
    /// - Parameter value: 編集後のタイトルと本文
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func updateNote(from value: GrammarFormValue) throws {
        try repository.update(note, from: value)
        errorMessage = nil
    }
    
    /// 表示中の英文法メモを削除
    /// - Returns: 削除に成功した場合は`true`、失敗した場合は`false`
    func deleteNote() -> Bool {
        do {
            try repository.delete(note)
            errorMessage = nil
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
