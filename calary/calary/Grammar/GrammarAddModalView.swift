//
//  GrammarAddModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarFormValue: Equatable {
    let title: String
    let content: String
}

struct GrammarAddModalView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var content: String

    let isEditing: Bool
    let onSave: (GrammarFormValue) -> Void

    init(
        initialValue: GrammarFormValue? = nil,
        onSave: @escaping (GrammarFormValue) -> Void = { _ in }
    ) {
        _title = State(initialValue: initialValue?.title ?? "")
        _content = State(initialValue: initialValue?.content ?? "")
        isEditing = initialValue != nil
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    inputSection(
                        label: "タイトル",
                        placeholder: "例：現在完了形（have been）",
                        text: $title,
                        minHeight: 52
                    )

                    inputSection(
                        label: "メモ",
                        placeholder: "文法の使い方や例文を入力してください",
                        text: $content,
                        minHeight: 240,
                        usesEditor: true
                    )
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(isEditing ? "英文法メモを編集" : "英文法メモを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(formValue)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
    }
}

private extension GrammarAddModalView {
    var formValue: GrammarFormValue {
        GrammarFormValue(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    var canSave: Bool {
        !formValue.title.isEmpty && !formValue.content.isEmpty
    }

    func inputSection(
        label: String,
        placeholder: String,
        text: Binding<String>,
        minHeight: CGFloat,
        usesEditor: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("HiraginoSans-W6", size: 15))
                .foregroundStyle(.textPrimary)

            if usesEditor {
                ZStack(alignment: .topLeading) {
                    if text.wrappedValue.isEmpty {
                        Text(placeholder)
                            .font(.custom("HiraginoSans-W3", size: 15))
                            .foregroundStyle(.textMuted)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: text)
                        .font(.custom("HiraginoSans-W3", size: 15))
                        .foregroundStyle(.textPrimary)
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .frame(minHeight: minHeight)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            } else {
                TextField(placeholder, text: text)
                    .font(.custom("HiraginoSans-W3", size: 15))
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal, 16)
                    .frame(minHeight: minHeight)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            }
        }
    }
}

#Preview {
    GrammarAddModalView()
}

#Preview("編集") {
    GrammarAddModalView(
        initialValue: GrammarFormValue(
            title: "現在完了形（have been）",
            content: "過去から現在まで続いている状態や経験を表す。"
        )
    )
}
