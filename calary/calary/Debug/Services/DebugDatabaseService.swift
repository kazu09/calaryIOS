//
//  DebugDatabaseService.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

#if DEBUG
import Foundation
import SwiftData

@MainActor
protocol DebugDatabaseService {
    /// 全モデルの保存内容をXcodeコンソールへ出力する
    func dumpToConsole() throws
}

@MainActor
final class SwiftDataDebugDatabaseService: DebugDatabaseService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// 各モデルの件数、属性、関連先IDをXcodeコンソールへ出力する
    func dumpToConsole() throws {
        let diaries = try modelContext.fetch(FetchDescriptor<Diary>())
        let cards = try modelContext.fetch(FetchDescriptor<VocabularyCard>())
        let meanings = try modelContext.fetch(FetchDescriptor<VocabularyMeaning>())
        let grammarNotes = try modelContext.fetch(FetchDescriptor<GrammarNote>())
        let tags = try modelContext.fetch(FetchDescriptor<Tag>())
        
        var lines = [
            "========== SwiftData DB DUMP =========="
        ]
        
        lines.append("========== Diary ==========")
        
        lines.append("[Diary] count=\(diaries.count)\n◯------------------------------------◯")
        lines.append(contentsOf: diaries.map {
            "id=\($0.id.uuidString),\nentryDate=\($0.entryDate.ISO8601Format()),\nenglishText=\(PersistenceLogValue.string($0.englishText)),\njapaneseText=\(PersistenceLogValue.string($0.japaneseText)),\ndiaryTag=\(PersistenceLogValue.string($0.diaryTag)),\nteacherQuestion=\(PersistenceLogValue.string($0.teacherQuestion)),\nquestionStatus=\(PersistenceLogValue.string($0.teacherQuestionStatus)),\n------------------------------------"
        })
        
        lines.append("========== VocabularyCard ==========")
        
        lines.append("[VocabularyCard] count=\(cards.count)\n◯------------------------------------◯")
        lines.append(contentsOf: cards.map {
            "id=\($0.id.uuidString),\nword=\(PersistenceLogValue.string($0.word)),\ndisplayOrder=\($0.displayOrder),\ndiaryID=\(PersistenceLogValue.string($0.diary?.id.uuidString)),\n------------------------------------"
        })
        
        lines.append("========== VocabularyMeaning ==========")
        
        lines.append("[VocabularyMeaning] count=\(meanings.count)\n◯------------------------------------◯")
        lines.append(contentsOf: meanings.map {
            "id=\($0.id.uuidString),\njapaneseMeaning=\(PersistenceLogValue.string($0.japaneseMeaning)),\npartOfSpeech=\(PersistenceLogValue.string($0.partOfSpeech)),\ndisplayOrder=\($0.displayOrder),\ncardID=\(PersistenceLogValue.string($0.card?.id.uuidString))\n------------------------------------"
        })
        
        lines.append("========== GrammarNote ==========")
        
        lines.append("[GrammarNote] count=\(grammarNotes.count)\n◯------------------------------------◯")
        lines.append(contentsOf: grammarNotes.map {
            "id=\($0.id.uuidString),\ntitle=\(PersistenceLogValue.string($0.title)),\ncontent=\(PersistenceLogValue.string($0.content)),\ndiaryID=\(PersistenceLogValue.string($0.diary?.id.uuidString)),\n------------------------------------"
        })
        
        lines.append("========== Tag ==========")
        
        lines.append("[Tag] count=\(tags.count)\n◯------------------------------------◯")
        lines.append(contentsOf: tags.map {
            "id=\($0.id.uuidString),\nname=\(PersistenceLogValue.string($0.name)),\ntagType=\(PersistenceLogValue.string($0.tagType)) colorCode=\(PersistenceLogValue.string($0.colorCode)),\nisActive=\($0.isActive),\ndisplayOrder=\($0.displayOrder),\n------------------------------------"
        })
        
        lines.append("========== END DB DUMP ==========")
        print(lines.joined(separator: "\n"))
    }
}
#endif
