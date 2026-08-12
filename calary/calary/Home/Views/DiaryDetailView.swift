//
//  DiaryDetailView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI
import SwiftData

struct DiaryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: DiaryDetailViewModel
    
    @State private var isShowingWordAdd = false
    @State private var isShowingEditor = false
    @State private var isShowingDeleteConfirmation = false
    
    init(viewModel: DiaryDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
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
                    
                    textCard(title: "English", text: viewModel.diary.englishText)
                    textCard(title: "日本語", text: viewModel.diary.japaneseText)
                    
                    if let teacherQuestion = viewModel.diary.teacherQuestion,
                       !teacherQuestion.isEmpty {
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
        .sheet(isPresented: $isShowingWordAdd) {
            WordAddModalView(onSave: viewModel.addWord)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingEditor) {
            DiaryCreateView(
                initialValue: viewModel.formValue,
                diaryTags: viewModel.diary.diaryTag.map { [$0] } ?? [],
                onSave: viewModel.updateDiary
            )
        }
        .confirmationDialog(
            "この日記を削除しますか？",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("削除", role: .destructive) {
                if viewModel.deleteDiary() {
                    dismiss()
                }
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("日記に登録した単語も削除されます。")
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

private extension DiaryDetailView {
    var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(
                    viewModel.diary.entryDate.formatted(date: .long, time: .omitted),
                    systemImage: "calendar"
                )
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundStyle(.textPrimary)
                
                Spacer()
                
                if let status = viewModel.questionStatus {
                    Button(action: viewModel.toggleQuestionStatus) {
                        HStack(spacing: 5) {
                            Image(
                                systemName: viewModel.diary.teacherQuestionStatus == "resolved"
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            Text(status)
                        }
                        .font(.custom("HiraginoSans-W6", size: 12))
                        .foregroundStyle(.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.backgroundPrimary)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("タップして回答状態を切り替えます")
                }
            }
            
            if let diaryTag = viewModel.diary.diaryTag, !diaryTag.isEmpty {
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
    DiaryDetailPreview()
}

private struct DiaryDetailPreview: View {
    private let diary: Diary
    private let dependencies: AppDependencies
    
    init() {
        let modelContainer = AppModelContainer.preview()
        let diary = Diary(
            entryDate: .now,
            englishText: "I visited the park and studied English today.",
            japaneseText: "今日は公園へ行き、英語を勉強しました。",
            diaryTag: "自習",
            teacherQuestion: "What is the difference between study and learn?",
            teacherQuestionStatus: "open"
        )
        modelContainer.mainContext.insert(diary)
        try? modelContainer.mainContext.save()
        self.diary = diary
        dependencies = AppDependencies(modelContainer: modelContainer)
    }
    
    var body: some View {
        DiaryDetailView(
            viewModel: DiaryDetailViewModel(
                diary: diary,
                diaryRepository: dependencies.diaryRepository,
                vocabularyRepository: dependencies.vocabularyRepository
            )
        )
    }
}
