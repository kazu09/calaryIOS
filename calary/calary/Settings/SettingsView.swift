//
//  SettingsView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

// MARK: View
struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("設定")
                        .font(.system(size: 20))
                        .foregroundStyle(.textSecondary)
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 18)
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                }
                .background(Color.white)
                
                ScrollView {
                    VStack(spacing: 20) {
                        sectionCard {
                            cardView(
                                icon: "square.and.arrow.up",
                                title: "JSONエクスポート",
                                description: "保存済みの学習データをJSON形式で書き出します。",
                                detailDescription: "バックアップ用のJSONを書き出す仮画面です。"
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "square.and.arrow.down",
                                title: "JSONインポート",
                                description: "JSONを読み込み、既存データを全置換で復元します。",
                                detailDescription: "復元前の確認を行う仮画面です。"
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "tag",
                                title: "タグ一覧",
                                description: "日記や学習内容で使うタグを一覧で確認できます。",
                                detailDescription: "利用中のタグを確認する仮画面です。"
                            )
                        }
                        
                        sectionCard {
                            cardView(
                                icon: "info.circle",
                                title: "アプリバージョン",
                                description: "現在のアプリバージョンを確認できます。",
                                detailDescription: "現在のバージョン情報を確認する仮画面です。"
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "doc.text",
                                title: "利用規約",
                                description: "アプリの利用条件やポリシーを確認できます。",
                                detailDescription: "利用規約を確認する仮画面です。"
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "questionmark.circle",
                                title: "ヘルプ",
                                description: "使い方やよくある質問を確認できます。",
                                detailDescription: "使い方やよくある質問を確認する仮画面です。"
                            )
                        }
                    }
                    .padding(16)
                }
                .background(Color.backgroundPrimary)
            }
        }
    }
}

// MARK: Private Method

private extension SettingsView {
    var rowDivider: some View {
        Divider()
            .padding(.leading, 72)
    }
    
    func cardView(
        icon: String,
        title: String,
        description: String,
        detailDescription: String
    ) -> some View {
        NavigationLink {
            SettingsPlaceholderDetailView(
                title: title,
                description: detailDescription
            )
        } label: {
            SettingsRowView(
                systemImageName: icon,
                title: title,
                description: description
            )
        }
        .buttonStyle(.plain)
    }
    
    func sectionCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

// MARK: preview
#Preview {
    SettingsView()
}
