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
    
    /// DB出力を実行し、成功または失敗の結果を画面表示用メッセージへ反映させる
    func dumpDatabaseToConsole() {
        do {
            try databaseService.dumpToConsole()
            alertTitle = String(localized: "debug.database.dump.success.title")
            alertMessage = String(localized: "debug.database.dump.success.message")
        } catch {
            alertTitle = String(localized: "debug.database.dump.error.title")
            alertMessage = error.localizedDescription
        }
    }
}
#endif
