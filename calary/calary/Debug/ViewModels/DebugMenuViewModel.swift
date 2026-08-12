//
//  DebugMenuViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

#if DEBUG
import Foundation
import Observation

@MainActor
@Observable
final class DebugMenuViewModel {
    private let databaseService: any DebugDatabaseService
    
    var alertTitle = ""
    var alertMessage: String?
    
    init(databaseService: any DebugDatabaseService) {
        self.databaseService = databaseService
    }
    
    func dumpDatabaseToConsole() {
        do {
            try databaseService.dumpToConsole()
            alertTitle = "ログ出力完了"
            alertMessage = "XcodeコンソールへDBの内容を出力しました。"
        } catch {
            alertTitle = "ログ出力エラー"
            alertMessage = error.localizedDescription
        }
    }
}
#endif
