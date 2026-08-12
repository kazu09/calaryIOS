//
//  DiaryDetailView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWordAdd = false
    @State private var isShowingEditor = false

    let entryDate: String
    let entryDateValue: Date
    let englishText: String
    let japaneseText: String
    let diaryTag: String?
    let teacherQuestion: String?
    let questionStatus: String?

    init(
        entryDate: String,
        entryDateValue: Date = .now,
        englishText: String,
        japaneseText: String,
        diaryTag: String? = nil,
        teacherQuestion: String? = nil,
        questionStatus: String? = nil
    ) {
        self.entryDate = entryDate
        self.entryDateValue = entryDateValue
        self.englishText = englishText
        self.japaneseText = japaneseText
        self.diaryTag = diaryTag
        self.teacherQuestion = teacherQuestion
        self.questionStatus = questionStatus
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    overviewCard

                    DiaryActionBar(
                        isEnabled: true,
                        showsGrammarAction: false,
                        onAddWord: {
                            isShowingWordAdd = true
                        },
                        onAddGrammar: {}
                    )

                    textCard(title: "English", text: englishText)
                    textCard(title: "日本語", text: japaneseText)

                    if let teacherQuestion, !teacherQuestion.isEmpty {
                        textCard(title: "先生への質問", text: teacherQuestion)
                    }
                }
                .padding(16)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("日記詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("編集") {
                        isShowingEditor = true
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingWordAdd) {
            WordAddModalView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingEditor) {
            DiaryCreateView(
                initialValue: DiaryFormValue(
                    entryDate: entryDateValue,
                    englishText: englishText,
                    japaneseText: japaneseText,
                    diaryTag: diaryTag,
                    teacherQuestion: teacherQuestion ?? ""
                ),
                diaryTags: diaryTag.map { [$0] } ?? []
            )
        }
    }
}

private extension DiaryDetailView {
    var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(entryDate, systemImage: "calendar")
                    .font(.custom("HiraginoSans-W6", size: 16))
                    .foregroundStyle(.textPrimary)

                Spacer()

                if let questionStatus, !questionStatus.isEmpty {
                    Text(questionStatus)
                        .font(.custom("HiraginoSans-W6", size: 12))
                        .foregroundStyle(.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.backgroundPrimary)
                        .clipShape(Capsule())
                }
            }

            if let diaryTag, !diaryTag.isEmpty {
                Label(diaryTag, systemImage: "tag")
                    .font(.custom("HiraginoSans-W3", size: 13))
                    .foregroundStyle(.textTertiary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }

    func textCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundStyle(.textSecondary)

            Text(text)
                .font(.custom("HiraginoSans-W3", size: 15))
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    DiaryDetailView(
        entryDate: "April, 30",
        englishText: "I visited the park and studied English today.",
        japaneseText: "今日は公園へ行き、英語を勉強しました。",
        diaryTag: "自習",
        teacherQuestion: "What is the difference between study and learn?",
        questionStatus: "未回答"
    )
}
