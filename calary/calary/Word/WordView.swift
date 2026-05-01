//
//  WordView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordView: View {
    @State private var isShowingDetail = false
    @State private var word = "book"
    @State private var diaryDate = "2026-4-24 の日記より"
    var body: some View {
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
                    Text("word.title")
                        .font(.system(size: 20))
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
            ScrollView{
                VStack {
                    WordCardView(
                        onCardTap: {
                            isShowingDetail = true
                        },
                        onDiaryTap: {
                            print("日記詳細へ")
                        },
                        word: word,
                        diaryDate: diaryDate
                    )
                    .sheet(isPresented: $isShowingDetail) {
                        Text("ハーフモーダルの中身")
                            .presentationDetents([.medium])
                    }
                    .padding(16)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundPrimary)
            }
        }
        .background(Color.backgroundPrimary)
    }
}
#Preview {
    WordView()
}
