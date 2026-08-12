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
    
    func updateNote(from value: GrammarFormValue) throws {
        try repository.update(note, from: value)
        errorMessage = nil
    }
    
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
