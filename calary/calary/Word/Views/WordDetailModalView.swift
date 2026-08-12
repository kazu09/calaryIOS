//
//  WordDetailModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI
import SwiftData

struct WordDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: WordDetailViewModel
    @State private var isShowingEditor = false
    
    init(viewModel: WordDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.card.word)
                        .font(.custom("HiraginoSans-W6", size: 30))
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.sortedMeanings) { meaning in
                            meaningRow(
                                number: meaning.displayOrder + 1,
                                meaning: meaning
                            )
                            
                            if meaning.id != viewModel.sortedMeanings.last?.id {
                                Divider()
                                    .padding(.leading, 44)
                            }
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
                    
                    if let diary = viewModel.card.diary {
                        HStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 16, weight: .semibold))
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("登録元の日記")
                                    .font(.custom("HiraginoSans-W3", size: 12))
                                    .foregroundStyle(.textTertiary)
                                
                                Text(diary.entryDate.formatted(date: .long, time: .omitted))
                                    .font(.custom("HiraginoSans-W6", size: 14))
                                    .foregroundStyle(.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("単語詳細")
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
            WordAddModalView(
                initialValue: viewModel.editorInitialValue,
                onSave: viewModel.updateCard
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
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

private extension WordDetailModalView {
    func meaningRow(
        number: Int,
        meaning: VocabularyMeaning
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("\(number).")
                .font(.custom("HiraginoSans-W6", size: 14))
                .foregroundStyle(.textTertiary)
                .frame(width: 24, alignment: .trailing)
            
            Text(meaning.japaneseMeaning)
                .font(.custom("HiraginoSans-W3", size: 16))
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let partOfSpeech = meaning.partOfSpeech {
                Text(partOfSpeech)
                    .font(.custom("HiraginoSans-W6", size: 11))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Color.textSecondary.opacity(0.82))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
}

#Preview {
    WordDetailModalPreview()
}

private struct WordDetailModalPreview: View {
    private let card: VocabularyCard
    private let repository: any VocabularyRepository
    
    init() {
        let modelContainer = AppModelContainer.preview()
        let dependencies = AppDependencies(modelContainer: modelContainer)
        let card = VocabularyCard(word: "book")
        let noun = VocabularyMeaning(
            japaneseMeaning: "本",
            partOfSpeech: "名詞",
            displayOrder: 0
        )
        let verb = VocabularyMeaning(
            japaneseMeaning: "予約する",
            partOfSpeech: "動詞",
            displayOrder: 1
        )
        modelContainer.mainContext.insert(card)
        modelContainer.mainContext.insert(noun)
        modelContainer.mainContext.insert(verb)
        card.meanings = [noun, verb]
        try? modelContainer.mainContext.save()
        self.card = card
        repository = dependencies.vocabularyRepository
    }
    
    var body: some View {
        WordDetailModalView(
            viewModel: WordDetailViewModel(
                card: card,
                repository: repository
            )
        )
    }
}
