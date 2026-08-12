//
//  GrammarDetailModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI
import SwiftData

struct GrammarDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GrammarDetailViewModel
    @State private var isShowingEditor = false
    @State private var isShowingDeleteConfirmation = false
    
    init(viewModel: GrammarDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(viewModel.note.title)
                            .font(.custom("HiraginoSans-W6", size: 24))
                            .foregroundStyle(.textPrimary)
                        
                        Divider()
                        
                        Text(viewModel.note.content)
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
                    
                    Label(
                        "更新日：\(viewModel.note.updatedAt.formatted(date: .numeric, time: .omitted))",
                        systemImage: "clock"
                    )
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
                    Menu {
                        Button("編集") {
                            isShowingEditor = true
                        }
                        
                        Button("削除", role: .destructive) {
                            isShowingDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingEditor) {
            GrammarAddModalView(
                initialValue: GrammarFormValue(
                    title: viewModel.note.title,
                    content: viewModel.note.content
                ),
                onSave: viewModel.updateNote
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .confirmationDialog(
            "この英文法メモを削除しますか？",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("削除", role: .destructive) {
                if viewModel.deleteNote() {
                    dismiss()
                }
            }
            Button("キャンセル", role: .cancel) {}
        }
        .alert(
            "保存エラー",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    GrammarDetailPreview()
}

private struct GrammarDetailPreview: View {
    private let note: GrammarNote
    private let dependencies: AppDependencies
    
    init() {
        let modelContainer = AppModelContainer.preview()
        let note = GrammarNote(
            title: "現在完了形（have been）",
            content: "過去から現在まで続いている状態や経験を表す。\n\n例：I have been studying English for three years."
        )
        modelContainer.mainContext.insert(note)
        try? modelContainer.mainContext.save()
        self.note = note
        dependencies = AppDependencies(modelContainer: modelContainer)
    }
    
    var body: some View {
        GrammarDetailModalView(
            viewModel: GrammarDetailViewModel(
                note: note,
                repository: dependencies.grammarRepository
            )
        )
    }
}
