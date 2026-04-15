//
//  DiaryCardView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                Text("April, 30")
                    .foregroundStyle(.diaryCardText)
                    .font(.custom("HiraginoSans-W3", size: 14))
                    .fontWeight(.bold)
                Spacer()
                Text("未回答")
                    .foregroundStyle(.notAnswertext)
                    .font(.custom("HiraginoSans-W3", size: 14))
                    .fontWeight(.bold)
            }
            .padding(.bottom, 14)
            Text("TitleTitleTitle")
                .foregroundStyle(.text)
                .font(.custom("HiraginoSans-W3", size: 14))
            Text("タイトルタイトルタイトル")
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
    DiaryCardView()
}
