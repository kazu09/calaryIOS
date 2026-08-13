# カラリー（Calary）

カラリーは、英語日記を中心に、日々学んだ単語や英文法をまとめて記録・復習するためのiOSアプリです。

英語と日本語で日記を書き、その日記で出会った単語を意味・品詞とともに保存できます。英文法は独立したメモとして残せるため、日々のアウトプットと学習内容を1つのアプリで管理できます。

## 主な機能

### 日記

- 英語と日本語の本文をセットで記録
- 月ごとの日記一覧表示
- 日付と先生への質問を保存
- 日記の編集・削除
- 先生への質問を未確認・確認済みで管理

### 単語

- 保存済みの日記から単語を登録
- 1つの単語に複数の日本語訳を追加
- 意味ごとに名詞・動詞・形容詞などの品詞を設定
- 登録した単語の一覧・詳細表示・編集
- 単語を登録した日記の日付を確認

### 英文法

- 英文法メモの作成
- メモの一覧・詳細表示
- メモの編集・削除

### 設定

- 本アプリの各種設定

### データ保存

- SwiftDataによる端末内へのローカル保存
- Xcode Previewでは実データに影響しないインメモリデータベースを使用

## アプリUI

<img width="600" alt="スクリーンショット 2026-08-13 21 56 40" src="https://github.com/user-attachments/assets/48f8794f-59d5-4bcb-af80-30a3b90f6c0e" />


## 技術構成

- Swift
- SwiftUI
- SwiftData
- Repositoryパターン

## 動作環境

- iOS 17.6以上
- iOS 17.6をサポートするXcode

外部ライブラリは使用していません。

## ディレクトリ構成

```text
calaryIOS/
├── calary/
│   ├── calary.xcodeproj/
│   ├── calary/
│   │   ├── App/          # アプリのエントリーポイントと依存関係
│   │   ├── Home/         # 日記機能
│   │   ├── Word/         # 単語機能
│   │   ├── Grammar/      # 英文法メモ機能
│   │   ├── Settings/     # 設定画面
│   │   ├── Persistence/  # SwiftDataモデルとRepository
│   │   ├── Resources/    # 画像、カラー、ローカライズ
│   │   └── Debug/        # DEBUGビルド専用ツール
│   ├── calaryTests/
│   └── calaryUITests/
├── README.md
└── LICENSE
```

## License

This project is licensed under the [MIT License](LICENSE).
