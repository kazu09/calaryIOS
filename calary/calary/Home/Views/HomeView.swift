//
//  HomeView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @State private var isShowingDiaryCreate = false
    @State private var selectedDiary: Diary?
    
    private let diaryRepository: any DiaryRepository
    private let vocabularyRepository: any VocabularyRepository
    
    init(
        diaryRepository: any DiaryRepository,
        vocabularyRepository: any VocabularyRepository
    ) {
        self.diaryRepository = diaryRepository
        self.vocabularyRepository = vocabularyRepository
        _viewModel = State(
            initialValue: HomeViewModel(repository: diaryRepository)
        )
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                appHeader
                monthSelector
                Divider()
                
                if viewModel.displayedDiaries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.displayedDiaries) { diary in
                                DiaryCardView(
                                    cardDate: diary.entryDate.formatted(
                                        .dateTime.month(.abbreviated).day()
                                    ),
                                    checkAnswer: viewModel.questionStatus(for: diary),
                                    enTitle: diary.englishText,
                                    jaTitle: diary.japaneseText,
                                    onTap: {
                                        selectedDiary = diary
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
        .fullScreenCover(isPresented: $isShowingDiaryCreate) {
            DiaryCreateView(onSave: viewModel.createDiary)
        }
        .fullScreenCover(
            item: $selectedDiary,
            onDismiss: { viewModel.load() }
        ) { diary in
            DiaryDetailView(
                viewModel: DiaryDetailViewModel(
                    diary: diary,
                    diaryRepository: diaryRepository,
                    vocabularyRepository: vocabularyRepository
                )
            )
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

private extension HomeView {
    var appHeader: some View {
        HStack {
            Spacer()
            
            Button {
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                    .foregroundStyle(.textSecondary)
            }
        }
        .overlay {
            Text("app.name")
                .font(.system(size: 24))
                .foregroundStyle(.textSecondary)
                .bold()
                .italic()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 18)
    }
    
    var monthSelector: some View {
        HStack {
            Button {
                viewModel.moveMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.textPrimary)
                    .padding(.leading, 12)
                    .padding(.trailing, 4)
            }
            
            Text(viewModel.displayedMonth.formatted(.dateTime.year().month(.wide)))
                .font(.system(size: 24))
                .foregroundStyle(.textPrimary)
                .bold()
                .italic()
            
            Button {
                viewModel.moveMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.textPrimary)
                    .padding(.leading, 4)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var emptyState: some View {
        ContentUnavailableView(
            "diary.empty.title",
            systemImage: "book.pages",
            description: Text("diary.empty.message")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isShowingDiaryCreate = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color(red: 0, green: 0, blue: 0.47))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("diary.create.action")
                .padding(24)
            }
        }
    }
}

#Preview {
    HomePreview()
}

private struct HomePreview: View {
    private let dependencies = AppDependencies.preview()
    
    var body: some View {
        HomeView(
            diaryRepository: dependencies.diaryRepository,
            vocabularyRepository: dependencies.vocabularyRepository
        )
    }
}
