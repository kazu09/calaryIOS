//
//  WordView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordView: View {
    @State private var viewModel: WordViewModel
    @State private var selectedCard: VocabularyCard?
    
    private let repository: any VocabularyRepository
    
    init(repository: any VocabularyRepository) {
        self.repository = repository
        _viewModel = State(initialValue: WordViewModel(repository: repository))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.cards.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("word.empty.title")
                    } icon: {
                        Image("card")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                } description: {
                    Text("word.empty.message")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.cards) { card in
                            WordCardView(
                                onCardTap: {
                                    selectedCard = card
                                },
                                onDiaryTap: {
                                    selectedCard = card
                                },
                                word: card.word,
                                diaryDate: viewModel.diaryDate(for: card)
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.backgroundPrimary)
        .sheet(
            item: $selectedCard,
            onDismiss: { viewModel.load() }
        ) { card in
            WordDetailModalView(
                viewModel: WordDetailViewModel(
                    card: card,
                    repository: repository
                )
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .task { viewModel.load() }
        .alert(
            "common.error.load.title",
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

private extension WordView {
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
                Text("word.title")
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
    
}

#Preview {
    WordPreview()
}

private struct WordPreview: View {
    private let dependencies = AppDependencies.preview()
    
    var body: some View {
        WordView(repository: dependencies.vocabularyRepository)
    }
}
