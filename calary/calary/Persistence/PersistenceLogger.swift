//
//  PersistenceLogger.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import OSLog
import SwiftData

/// 永続化ログへ記録するデータ操作の種類。
enum PersistenceAction: String {
    case create = "CREATE"
    case update = "UPDATE"
    case delete = "DELETE"
}

/// SwiftDataの保存結果をXcodeコンソールへ出力するロガー。
enum PersistenceLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "calary",
        category: "Persistence"
    )
    
    /// 保存に成功した操作と対象データの詳細を記録する。
    static func success(
        action: PersistenceAction,
        entity: String,
        id: UUID,
        details: String
    ) {
#if DEBUG
        let normalizedDetails = normalize(details)
        logger.info(
            "[\(action.rawValue, privacy: .public)] \(entity, privacy: .public) id=\(id.uuidString, privacy: .public) \(normalizedDetails, privacy: .public)"
        )
#endif
    }
    
    /// 保存に失敗した操作、対象データ、エラー内容を記録する。
    static func failure(
        action: PersistenceAction,
        entity: String,
        id: UUID,
        details: String,
        error: Error
    ) {
#if DEBUG
        let normalizedDetails = normalize(details)
        logger.error(
            "[\(action.rawValue, privacy: .public) FAILED] \(entity, privacy: .public) id=\(id.uuidString, privacy: .public) \(normalizedDetails, privacy: .public) error=\(error.localizedDescription, privacy: .public)"
        )
#endif
    }
    
    private static func normalize(_ details: String) -> String {
        details
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
    }
}

/// Optional文字列を永続化ログ向けの表現へ変換する。
enum PersistenceLogValue {
    /// 値を引用符で囲み、改行などをエスケープして返す。`nil`は文字列`nil`として返す。
    static func string(_ value: String?) -> String {
        guard let value else { return "nil" }
        let escaped = value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
        return "\"\(escaped)\""
    }
}

extension ModelContext {
    /// コンテキストを保存し、成否とデータの詳細をログへ記録する
    ///
    /// 保存に失敗した場合は未保存の変更をロールバックし、元のエラーを呼び出し元へ返す
    func saveWithLog(
        action: PersistenceAction,
        entity: String,
        id: UUID,
        details: String
    ) throws {
        do {
            try save()
            PersistenceLogger.success(
                action: action,
                entity: entity,
                id: id,
                details: details
            )
        } catch {
            PersistenceLogger.failure(
                action: action,
                entity: entity,
                id: id,
                details: details,
                error: error
            )
            rollback()
            throw error
        }
    }
}
