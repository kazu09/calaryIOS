//
//  WordCardView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct WordCardView: View {
    var onCardTap: () -> Void = {}
    var onDiaryTap: () -> Void = {}
    let word: String
    let diaryDate: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(word)
                .foregroundStyle(.text)
                .font(.custom("HiraginoSans-W3", size: 24))
                .bold()
                .padding(.top, 10)
                .padding(.leading, 12)

            Button {
                onDiaryTap()
            } label: {
                HStack(spacing: 4) {
                    Text(diaryDate)
                        .foregroundStyle(.diaryCardText)
                        .font(.custom("HiraginoSans-W3", size: 12))
                        .underline()

                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.diaryCardText)
                }
                .padding(.top, 6)
                .padding(.leading, 12)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            onCardTap()
        }
    }
}

#Preview {
    WordCardView(
        word: "book",
        diaryDate: "2026-4-24 の日記より"

    )
}
