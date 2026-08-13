//
//  GrammarAddModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

/// 英文法メモのタイトルと本文を追加または編集するモーダル画面
struct GrammarAddModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var content: String
    @State private var errorMessage: String?
    
    let isEditing: Bool
    let onSave: (GrammarFormValue) throws -> Void
    
    /// 新規追加用または編集用の英文法メモ入力画面を生成する
    /// - Parameter initialValue: 編集対象の初期値。`nil`の場合は新規追加として表示
    init(
        initialValue: GrammarFormValue? = nil,
        onSave: @escaping (GrammarFormValue) throws -> Void = { _ in }
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
                        label: String(localized: "grammar.field.title"),
                        placeholder: String(localized: "grammar.field.title.placeholder"),
                        text: $title,
                        minHeight: 52
                    )
                    
                    inputSection(
                        label: String(localized: "grammar.field.content"),
                        placeholder: String(localized: "grammar.field.content.placeholder"),
                        text: $content,
                        minHeight: 240,
                        usesEditor: true
                    )
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(
                isEditing
                    ? String(localized: "grammar.edit.title")
                    : String(localized: "grammar.add.title")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
        .alert(
            "common.error.save.title",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
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

    func save() {
        do {
            try onSave(formValue)
            dismiss()
        } catch {
            errorMessage = String(
                localized: "common.error.save.message"
            )
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
