//
//  GrammarView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarView: View {
    @State private var isShowingDetail = false
    @State private var isShowingAdd = false

    private let title = "現在完了形（have been）"
    private let content = "過去から現在まで続いている状態や経験を表す。"
    private let updatedDate = "2026/4/30"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
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
                        Text("英文法メモ")
                            .font(.system(size: 18))
                            .foregroundStyle(.textSecondary)
                            .font(.custom("HiraginoSans-W3", size: 14))
                            .bold()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 18)

                    Divider()
                }
                .background(Color.white)
                ScrollView {
                    VStack {
                        GrammarCardView(
                            title: title,
                            content: content,
                            updatedDate: updatedDate,
                            onGrammarCardTap: {
                                isShowingDetail = true
                            }
                        )
                        .padding(16)
                        Spacer()
                    }
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isShowingAdd = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 0, green: 0, blue: 0.47))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                    }
                    .accessibilityLabel("英文法メモを追加")
                    .padding(24)
                }
            }
        }
        .background(Color.backgroundPrimary)
        .sheet(isPresented: $isShowingDetail) {
            GrammarDetailModalView(
                title: title,
                content: content,
                updatedDate: updatedDate
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingAdd) {
            GrammarAddModalView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    GrammarView()
}
