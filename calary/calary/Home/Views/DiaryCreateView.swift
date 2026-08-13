//
//  DiaryCreateView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var entryDate = Date()
    @State private var englishText = ""
    @State private var japaneseText = ""
    @State private var selectedTag: String?
    @State private var teacherQuestion = ""
    @State private var errorMessage: String?
    
    let isEditing: Bool
    let diaryTags: [String]
    let onSave: (DiaryFormValue) throws -> Void
    
    /// 新規作成用または編集用の日記入力画面を生成
    /// - Parameter initialValue: 編集対象の初期値。`nil`の場合は新規作成として表示
    init(
        initialValue: DiaryFormValue? = nil,
        diaryTags: [String] = [],
        onSave: @escaping (DiaryFormValue) throws -> Void = { _ in }
    ) {
        _entryDate = State(initialValue: initialValue?.entryDate ?? Date())
        _englishText = State(initialValue: initialValue?.englishText ?? "")
        _japaneseText = State(initialValue: initialValue?.japaneseText ?? "")
        _selectedTag = State(initialValue: initialValue?.diaryTag)
        _teacherQuestion = State(initialValue: initialValue?.teacherQuestion ?? "")
        isEditing = initialValue != nil
        self.diaryTags = diaryTags
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                VStack(spacing: 20) {
                    DiaryMetaSection(
                        entryDate: $entryDate,
                        selectedTag: $selectedTag,
                        diaryTags: diaryTags
                    )
                    
                    DiaryTextSection(
                        title: String(localized: "diary.field.english"),
                        placeholder: String(localized: "diary.field.english.placeholder"),
                        text: $englishText
                    )
                    
                    DiaryTextSection(
                        title: String(localized: "diary.field.japanese"),
                        placeholder: String(localized: "diary.field.japanese.placeholder"),
                        text: $japaneseText
                    )
                    
                    DiaryQuestionSection(teacherQuestion: $teacherQuestion)
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(diaryBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
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

private extension DiaryCreateView {
    var diaryBackground: Color {
        Color(red: 0, green: 0, blue: 0.47)
    }
    
    var formValue: DiaryFormValue {
        DiaryFormValue(
            entryDate: entryDate,
            englishText: englishText.trimmingCharacters(in: .whitespacesAndNewlines),
            japaneseText: japaneseText.trimmingCharacters(in: .whitespacesAndNewlines),
            diaryTag: selectedTag,
            teacherQuestion: teacherQuestion.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    var canSave: Bool {
        !formValue.englishText.isEmpty && !formValue.japaneseText.isEmpty
    }
    
    var header: some View {
        HStack(spacing: 12) {
            Button("common.cancel") {
                dismiss()
            }
            .font(.custom("HiraginoSans-W3", size: 14))
            .foregroundStyle(.white.opacity(0.85))
            
            Spacer()
            
            Text(
                isEditing
                    ? String(localized: "diary.edit.title")
                    : String(localized: "diary.create.title")
            )
                .font(.custom("HiraginoSans-W6", size: 17))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button("common.save") {
                save()
            }
            .font(.custom("HiraginoSans-W6", size: 14))
            .foregroundStyle(.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(red: 0.91, green: 0.73, blue: 0.25))
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .opacity(canSave ? 1 : 0.45)
            .disabled(!canSave)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(diaryBackground)
        .overlay(alignment: .bottom) {
            Divider().overlay(.white.opacity(0.18))
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
    DiaryCreateView(diaryTags: ["授業", "自習", "宿題"])
}

#Preview("編集") {
    DiaryCreateView(
        initialValue: DiaryFormValue(
            entryDate: .now,
            englishText: "I studied English today.",
            japaneseText: "今日は英語を勉強しました。",
            diaryTag: "自習",
            teacherQuestion: "What is the difference between study and learn?"
        ),
        diaryTags: ["授業", "自習", "宿題"]
    )
}
