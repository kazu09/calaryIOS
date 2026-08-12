//
//  GrammarDetailModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingEditor = false

    let title: String
    let content: String
    let updatedDate: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(title)
                            .font(.custom("HiraginoSans-W6", size: 24))
                            .foregroundStyle(.textPrimary)

                        Divider()

                        Text(content)
                            .font(.custom("HiraginoSans-W3", size: 15))
                            .foregroundStyle(.textPrimary)
                            .lineSpacing(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)

                    Label("更新日：\(updatedDate)", systemImage: "clock")
                        .font(.custom("HiraginoSans-W3", size: 12))
                        .foregroundStyle(.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("英文法メモ詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("編集") {
                        isShowingEditor = true
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingEditor) {
            GrammarAddModalView(
                initialValue: GrammarFormValue(
                    title: title,
                    content: content
                )
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    GrammarDetailModalView(
        title: "現在完了形（have been）",
        content: "過去から現在まで続いている状態や経験を表す。\n\n例：I have been studying English for three years.",
        updatedDate: "2026/4/30"
    )
}
