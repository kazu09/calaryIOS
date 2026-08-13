//
//  SettingsView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

// MARK: View
/// アプリ設定と、DEBUGビルド時の開発者メニューへの入口を表示する画面。
struct SettingsView: View {
    let dependencies: AppDependencies
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("settings.title")
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
                        //                   機能としては必須ではないためコメントアウトで未表示
                        //                        sectionCard {
                        //                            cardView(
                        //                                icon: "square.and.arrow.up",
                        //                                title: "JSONエクスポート",
                        //                                description: "保存済みの学習データをJSON形式で書き出します。",
                        //                                detailDescription: "バックアップ用のJSONを書き出す仮画面です。"
                        //                            )
                        //
                        //                            rowDivider
                        //
                        //                            cardView(
                        //                                icon: "square.and.arrow.down",
                        //                                title: "JSONインポート",
                        //                                description: "JSONを読み込み、既存データを全置換で復元します。",
                        //                                detailDescription: "復元前の確認を行う仮画面です。"
                        //                            )
                        //
                        //                            rowDivider
                        //
                        //                            cardView(
                        //                                icon: "tag",
                        //                                title: "タグ一覧",
                        //                                description: "日記や学習内容で使うタグを一覧で確認できます。",
                        //                                detailDescription: "利用中のタグを確認する仮画面です。"
                        //                            )
                        //                        }
                        
                        sectionCard {
                            cardView(
                                icon: "info.circle",
                                title: String(localized: "settings.app_version.title"),
                                description: String(localized: "settings.app_version.description"),
                                detailDescription: String(localized: "settings.app_version.detail")
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "doc.text",
                                title: String(localized: "settings.terms.title"),
                                description: String(localized: "settings.terms.description"),
                                detailDescription: String(localized: "settings.terms.detail")
                            )
                            
                            rowDivider
                            
                            cardView(
                                icon: "questionmark.circle",
                                title: String(localized: "settings.help.title"),
                                description: String(localized: "settings.help.description"),
                                detailDescription: String(localized: "settings.help.detail")
                            )
                        }
                        // デバッグモードでのみ表示
#if DEBUG
                        sectionCard {
                            NavigationLink {
                                DebugMenuView(
                                    viewModel: DebugMenuViewModel(
                                        databaseService: dependencies.debugDatabaseService
                                    )
                                )
                            } label: {
                                SettingsRowView(
                                    systemImageName: "ladybug",
                                    title: String(localized: "debug.title"),
                                    description: String(localized: "settings.debug.description")
                                )
                            }
                            .buttonStyle(.plain)
                        }
#endif
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
    SettingsPreview()
}

private struct SettingsPreview: View {
    private let dependencies = AppDependencies.preview()
    
    var body: some View {
        SettingsView(dependencies: dependencies)
    }
}
