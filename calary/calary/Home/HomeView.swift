//
//  HomeView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var cardDate = "April, 30"
    @State private var checkAnswer = "未回答"
    @State private var enTitle = "TitleTitleTitle"
    @State private var jaTitle = "タイトルタイトルタイトル"
    @State private var isShowingDiaryCreate = false
    @State private var isShowingDiaryDetail = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        // 設定画面へ
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(.textSecondary)
                    }
                }
                .overlay {
                    Text("Calary")
                        .font(.system(size: 24))
                        .foregroundStyle(.textSecondary)
                        .bold()
                        .italic()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 18)
                
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.textPrimary)
                            .padding(.leading,12)
                            .padding(.trailing,4)
                    }
                    
                    Text("2026年4月")
                        .font(.system(size: 24))
                        .foregroundStyle(.textPrimary)
                        .bold()
                        .italic()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.textPrimary)
                            .padding(.leading,4)
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ScrollView {
                    VStack {
                        DiaryCardView(
                            cardDate: cardDate,
                            checkAnswer: checkAnswer,
                            enTitle: enTitle,
                            jaTitle: jaTitle,
                            onTap: {
                                isShowingDiaryDetail = true
                            }
                        )
                    }
                    .padding(16)
                }
                Spacer()
            }

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
                    .accessibilityLabel("日記を新規作成")
                    .padding(24)
                }
            }
        }.background(Color.backgroundPrimary)
        .fullScreenCover(isPresented: $isShowingDiaryCreate) {
            DiaryCreateView()
        }
        .fullScreenCover(isPresented: $isShowingDiaryDetail) {
            DiaryDetailView(
                entryDate: cardDate,
                englishText: enTitle,
                japaneseText: jaTitle,
                teacherQuestion: "先生に確認したい質問がここに表示されます。",
                questionStatus: checkAnswer
            )
        }
    }
}

#Preview {
    HomeView()
}
