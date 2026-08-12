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
    
    func load() {
        do {
            notes = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createNote(from value: GrammarFormValue) throws {
        _ = try repository.create(from: value)
        load()
    }
}
