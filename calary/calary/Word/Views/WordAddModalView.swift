//
//  WordAddModalView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordAddModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var word = ""
    @State private var entries = [WordEntryDraft()]
    @State private var errorMessage: String?
    
    let isEditing: Bool
    let partOfSpeechOptions: [String]
    let onSave: (WordFormValue) throws -> Void
    
    init(
        initialValue: WordFormValue? = nil,
        partOfSpeechOptions: [String] = ["名詞", "動詞", "形容詞", "副詞", "その他"],
        onSave: @escaping (WordFormValue) throws -> Void = { _ in }
    ) {
        _word = State(initialValue: initialValue?.word ?? "")
        _entries = State(
            initialValue: initialValue?.entries.map {
                WordEntryDraft(
                    japaneseMeaning: $0.japaneseMeaning,
                    partOfSpeech: $0.partOfSpeech
                )
            } ?? [WordEntryDraft()]
        )
        isEditing = initialValue != nil
        self.partOfSpeechOptions = partOfSpeechOptions
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    wordSection
                    
                    VStack(spacing: 14) {
                        ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                            WordEntryRowView(
                                number: index + 1,
                                entry: binding(for: entry.id),
                                partOfSpeechOptions: partOfSpeechOptions,
                                canRemove: entries.count > 1,
                                onRemove: {
                                    removeEntry(id: entry.id)
                                }
                            )
                        }
                    }
                    
                    Button {
                        entries.append(WordEntryDraft())
                    } label: {
                        Label("意味を追加", systemImage: "plus.circle.fill")
                            .font(.custom("HiraginoSans-W6", size: 15))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.textSecondary)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(isEditing ? "単語を編集" : "単語を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
        .alert(
            "保存エラー",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

private extension WordAddModalView {
    var wordSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("英単語")
                .font(.custom("HiraginoSans-W6", size: 15))
                .foregroundStyle(.textPrimary)
            
            TextField("例：book", text: $word)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.custom("HiraginoSans-W3", size: 17))
                .foregroundStyle(.textPrimary)
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        }
    }
    
    var formValue: WordFormValue {
        WordFormValue(
            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
            entries: entries.map {
                WordMeaningValue(
                    japaneseMeaning: $0.japaneseMeaning.trimmingCharacters(in: .whitespacesAndNewlines),
                    partOfSpeech: $0.partOfSpeech
                )
            }
        )
    }
    
    var canSave: Bool {
        !formValue.word.isEmpty
        && !formValue.entries.isEmpty
        && formValue.entries.allSatisfy { !$0.japaneseMeaning.isEmpty }
    }
    
    func binding(for id: UUID) -> Binding<WordEntryDraft> {
        guard let index = entries.firstIndex(where: { $0.id == id }) else {
            preconditionFailure("Word entry not found")
        }
        return $entries[index]
    }
    
    func removeEntry(id: UUID) {
        guard entries.count > 1 else { return }
        entries.removeAll { $0.id == id }
    }

    func save() {
        do {
            try onSave(formValue)
            dismiss()
        } catch {
            errorMessage = String(
                localized: "保存できませんでした。時間をおいて、もう一度お試しください。"
            )
        }
    }
}

#Preview {
    WordAddModalView()
}

#Preview("編集") {
    WordAddModalView(
        initialValue: WordFormValue(
            word: "book",
            entries: [
                WordMeaningValue(
                    japaneseMeaning: "本",
                    partOfSpeech: "名詞"
                ),
                WordMeaningValue(
                    japaneseMeaning: "予約する",
                    partOfSpeech: "動詞"
                )
            ]
        )
    )
}
