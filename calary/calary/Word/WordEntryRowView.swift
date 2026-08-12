//
//  WordEntryRowView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordEntryDraft: Identifiable, Equatable {
    let id: UUID
    var japaneseMeaning: String
    var partOfSpeech: String?

    init(
        id: UUID = UUID(),
        japaneseMeaning: String = "",
        partOfSpeech: String? = nil
    ) {
        self.id = id
        self.japaneseMeaning = japaneseMeaning
        self.partOfSpeech = partOfSpeech
    }
}

struct WordEntryRowView: View {
    let number: Int
    @Binding var entry: WordEntryDraft
    let partOfSpeechOptions: [String]
    let canRemove: Bool
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("意味 \(number)")
                    .font(.custom("HiraginoSans-W6", size: 15))
                    .foregroundStyle(.textPrimary)

                Spacer()

                if canRemove {
                    Button(role: .destructive, action: onRemove) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .accessibilityLabel("意味\(number)を削除")
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("日本語訳")
                    .font(.custom("HiraginoSans-W3", size: 12))
                    .foregroundStyle(.textTertiary)

                TextField("例：本、予約する", text: $entry.japaneseMeaning)
                    .font(.custom("HiraginoSans-W3", size: 15))
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal, 14)
                    .frame(minHeight: 46)
                    .background(Color.backgroundPrimary.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("品詞（任意）")
                    .font(.custom("HiraginoSans-W3", size: 12))
                    .foregroundStyle(.textTertiary)

                Picker("品詞", selection: $entry.partOfSpeech) {
                    Text("選択なし").tag(nil as String?)
                    ForEach(partOfSpeechOptions, id: \.self) { option in
                        Text(option).tag(option as String?)
                    }
                }
                .pickerStyle(.menu)
                .tint(.textPrimary)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
                .background(Color.backgroundPrimary.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    WordEntryRowView(
        number: 1,
        entry: .constant(
            WordEntryDraft(
                japaneseMeaning: "本",
                partOfSpeech: "名詞"
            )
        ),
        partOfSpeechOptions: ["名詞", "動詞", "形容詞", "副詞"],
        canRemove: true,
        onRemove: {}
    )
    .padding()
    .background(Color.backgroundPrimary)
}
