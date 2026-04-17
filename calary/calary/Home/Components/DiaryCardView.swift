//
//  DiaryCardView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryCardView: View {
    let cardDate: String
    let checkAnswer: String
    let enTitle: String
    let jaTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                Text(cardDate)
                    .foregroundStyle(.diaryCardText)
                    .font(.custom("HiraginoSans-W3", size: 14))
                    .fontWeight(.bold)
                Spacer()
                Text(checkAnswer)
                    .foregroundStyle(.notAnswertext)
                    .font(.custom("HiraginoSans-W3", size: 14))
                    .fontWeight(.bold)
            }
            .padding(.bottom, 14)
            Text(enTitle)
                .foregroundStyle(.text)
                .font(.custom("HiraginoSans-W3", size: 14))
            Text(jaTitle)
                .foregroundStyle(.text)
                .font(.custom("HiraginoSans-W3", size: 14))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DiaryCardView(
        cardDate: "April, 30",
        checkAnswer: "未回答",
        enTitle: "TitleTitleTitle",
        jaTitle: "タイトルタイトルタイトル"
    )
}
