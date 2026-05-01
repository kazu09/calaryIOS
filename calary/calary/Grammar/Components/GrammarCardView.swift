//
//  GrammarCardView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarCardView: View {
    var onGrammarCardTap: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("現在完了形（have been）")
                .foregroundStyle(.textTertiary)
                .font(.custom("HiraginoSans-W6", size: 20))
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text(
                "TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText"
            )
            .foregroundStyle(.textPrimary)
            .font(.custom("HiraginoSans-W3", size: 14))
            .fontWeight(.bold)
            .padding(.bottom,8)
            .lineLimit(2)
            
            HStack {
                Spacer()
                Text("2026/4/30")
                    .foregroundStyle(.textPrimary)
                    .font(.custom("HiraginoSans-W3", size: 14))
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onGrammarCardTap()
        }
    }
}

#Preview {
    GrammarCardView()
}
