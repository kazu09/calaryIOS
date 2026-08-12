//
//  WordDetailModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordMeaningDisplayValue: Identifiable, Equatable {
    let id: UUID
    let japaneseMeaning: String
    let partOfSpeech: String?

    init(
        id: UUID = UUID(),
        japaneseMeaning: String,
        partOfSpeech: String? = nil
    ) {
        self.id = id
        self.japaneseMeaning = japaneseMeaning
        self.partOfSpeech = partOfSpeech
    }
}

struct WordDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingEditor = false

    let word: String
    let meanings: [WordMeaningDisplayValue]
    let diaryDate: String?
    let onDiaryTap: () -> Void

    init(
        word: String,
        meanings: [WordMeaningDisplayValue],
        diaryDate: String? = nil,
        onDiaryTap: @escaping () -> Void = {}
    ) {
        self.word = word
        self.meanings = meanings
        self.diaryDate = diaryDate
        self.onDiaryTap = onDiaryTap
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(word)
                        .font(.custom("HiraginoSans-W6", size: 30))
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 0) {
                        ForEach(Array(meanings.enumerated()), id: \.element.id) { index, meaning in
                            meaningRow(number: index + 1, meaning: meaning)

                            if meaning.id != meanings.last?.id {
                                Divider()
                                    .padding(.leading, 44)
                            }
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)

                    if let diaryDate, !diaryDate.isEmpty {
                        Button {
                            dismiss()
                            onDiaryTap()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "book.closed")
                                    .font(.system(size: 16, weight: .semibold))

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("登録元の日記")
                                        .font(.custom("HiraginoSans-W3", size: 12))
                                        .foregroundStyle(.textTertiary)

                                    Text(diaryDate)
                                        .font(.custom("HiraginoSans-W6", size: 14))
                                        .foregroundStyle(.textSecondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
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
                initialValue: WordFormValue(
                    word: word,
                    entries: meanings.map {
                        WordMeaningValue(
                            japaneseMeaning: $0.japaneseMeaning,
                            partOfSpeech: $0.partOfSpeech
                        )
                    }
                )
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

private extension WordDetailModalView {
    func meaningRow(
        number: Int,
        meaning: WordMeaningDisplayValue
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
    WordDetailModalView(
        word: "book",
        meanings: [
            WordMeaningDisplayValue(
                japaneseMeaning: "本",
                partOfSpeech: "名詞"
            ),
            WordMeaningDisplayValue(
                japaneseMeaning: "予約する",
                partOfSpeech: "動詞"
            )
        ],
        diaryDate: "2026年4月24日の日記"
    )
}
