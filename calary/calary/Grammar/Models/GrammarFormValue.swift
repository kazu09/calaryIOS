//
//  GrammarFormValue.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

/// 英文法メモの追加・編集画面からViewModelへ渡す入力値
struct GrammarFormValue: Equatable {
    /// 英文法メモのタイトル
    let title: String
    /// 文法の説明や例文を記録する本文
    let content: String
}
