//
//  DiaryFormValue.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation

/// SwiftDataモデルを入力画面へ直接Bindingせず、保存時の値をまとめて受け渡すために使用する
struct DiaryFormValue: Equatable {
    /// 日記の学習日
    let entryDate: Date
    /// 英語の日記本文
    let englishText: String
    /// 日本語の日記本文
    let japaneseText: String
    /// 選択された日記タグ名
    let diaryTag: String?
    /// 先生へ確認する質問。未入力の場合は空文字
    let teacherQuestion: String
}
