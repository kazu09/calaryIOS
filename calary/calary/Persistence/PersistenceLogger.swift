//
//  PersistenceLogger.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import OSLog
import SwiftData

enum PersistenceAction: String {
    case create = "CREATE"
    case update = "UPDATE"
    case delete = "DELETE"
}

enum PersistenceLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "calary",
        category: "Persistence"
    )
    
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

enum PersistenceLogValue {
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
