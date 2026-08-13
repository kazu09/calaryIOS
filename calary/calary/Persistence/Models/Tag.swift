//
//  Tag.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import SwiftData

/// アプリ内で使用する日記分類や品詞の選択肢を管理するモデル
// TODO: 現在のMVPでは各画面が文字列を直接保存しているため、このモデルはまだ使用していない。
@Model
final class Tag {
    /// タグを一意に識別するID
    @Attribute(.unique) var id: UUID
    /// 画面へ表示するタグ名
    var name: String
    /// タグの用途。日記分類は`diary`、品詞は`part_of_speech`
    var tagType: String
    /// タグの表示色を表すカラーコード
    var colorCode: String?
    /// 画面の選択肢として使用できるかどうか
    var isActive: Bool
    /// 同じ用途のタグ内での表示順
    var displayOrder: Int
    /// 作成日時
    var createdAt: Date
    /// 最終更新日時
    var updatedAt: Date
    
    /// 日記分類または品詞の選択肢を生成する
    /// - Parameters:
    ///   - id: タグを一意に識別するID
    ///   - name: 画面へ表示するタグ名
    ///   - tagType: タグの用途。`diary`または`part_of_speech`
    ///   - colorCode: タグの表示色を表すカラーコード
    ///   - isActive: 画面の選択肢として使用できるかどうか
    ///   - displayOrder: 同じ種類のタグ内での表示順
    ///   - createdAt: 作成日時
    ///   - updatedAt: 最終更新日時
    init(
        id: UUID = UUID(),
        name: String,
        tagType: String,
        colorCode: String? = nil,
        isActive: Bool = true,
        displayOrder: Int = 0,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.tagType = tagType
        self.colorCode = colorCode
        self.isActive = isActive
        self.displayOrder = displayOrder
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
