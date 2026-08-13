//
//  WordFormValue.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

struct WordFormValue: Equatable {
    /// 英単語の見出し。
    let word: String
    /// 英単語へ登録する日本語訳と品詞の一覧。
    let entries: [WordMeaningValue]
}

struct WordMeaningValue: Equatable {
    /// 日本語訳。
    let japaneseMeaning: String
    /// 日本語訳に対応する品詞。
    let partOfSpeech: String?
}
