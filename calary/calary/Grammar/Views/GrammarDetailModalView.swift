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
                        "grammar.detail.updated_at \(viewModel.note.updatedAt.formatted(date: .numeric, time: .omitted))",
                        systemImage: "clock"
                    )
                    .font(.custom("HiraginoSans-W3", size: 12))
                    .foregroundStyle(.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("grammar.detail.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button("common.edit") {
                            isShowingEditor = true
                        }
                        
                        Button("common.delete", role: .destructive) {
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
            "grammar.delete.confirmation.title",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("common.delete", role: .destructive) {
                if viewModel.deleteNote() {
                    dismiss()
                }
            }
            Button("common.cancel", role: .cancel) {}
        }
        .alert(
            "common.error.save.title",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("common.ok", role: .cancel) {}
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
