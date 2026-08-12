//
//  DiaryTextSection.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryTextSection: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundStyle(.white)

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("HiraginoSans-W3", size: 15))
                        .foregroundStyle(.textMuted)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .font(.custom("HiraginoSans-W3", size: 15))
                    .foregroundStyle(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .frame(minHeight: 150)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ZStack {
        Color.textSecondary.ignoresSafeArea()
        DiaryTextSection(
            title: "English",
            placeholder: "英語で日記を書いてください",
            text: .constant("")
        )
        .padding()
    }
}
