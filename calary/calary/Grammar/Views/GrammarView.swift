//
//  GrammarView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarView: View {
    @State private var viewModel: GrammarViewModel
    @State private var selectedNote: GrammarNote?
    @State private var isShowingAdd = false
    
    private let repository: any GrammarRepository
    
    init(repository: any GrammarRepository) {
        self.repository = repository
        _viewModel = State(initialValue: GrammarViewModel(repository: repository))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                if viewModel.notes.isEmpty {
                    ContentUnavailableView(
                        "grammar.empty.title",
                        systemImage: "book.closed",
                        description: Text("grammar.empty.message")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.notes) { note in
                                GrammarCardView(
                                    title: note.title,
                                    content: note.content,
                                    updatedDate: note.updatedAt.formatted(
                                        date: .numeric,
                                        time: .omitted
                                    ),
                                    onGrammarCardTap: {
                                        selectedNote = note
                                    }
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
            
            addButton
        }
        .background(Color.backgroundPrimary)
        .sheet(
            item: $selectedNote,
            onDismiss: { viewModel.load() }
        ) { note in
            GrammarDetailModalView(
                viewModel: GrammarDetailViewModel(
                    note: note,
                    repository: repository
                )
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingAdd) {
            GrammarAddModalView(onSave: viewModel.createNote)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .task { viewModel.load() }
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

private extension GrammarView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 20))
                        .foregroundStyle(.textSecondary)
                }
            }
            .overlay {
                Text("grammar.title")
                    .font(.custom("HiraginoSans-W6", size: 18))
                    .foregroundStyle(.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 18)
            
            Divider()
        }
        .background(Color.white)
    }
    
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isShowingAdd = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color(red: 0, green: 0, blue: 0.47))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("grammar.add.action")
                .padding(24)
            }
        }
    }
    
}

#Preview {
    GrammarPreview()
}

private struct GrammarPreview: View {
    private let dependencies = AppDependencies.preview()
    
    var body: some View {
        GrammarView(repository: dependencies.grammarRepository)
    }
}
