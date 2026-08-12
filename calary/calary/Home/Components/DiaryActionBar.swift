//
//  DiaryActionBar.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryActionBar: View {
    let isEnabled: Bool
    var showsGrammarAction = true
    let onAddWord: () -> Void
    let onAddGrammar: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            actionButton(
                title: "単語を追加",
                systemImage: "plus",
                action: onAddWord
            )

            if showsGrammarAction {
                actionButton(
                    title: "英文法メモを追加",
                    systemImage: "plus",
                    action: onAddGrammar
                )
            }
        }
    }
}

private extension DiaryActionBar {
    func actionButton(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.custom("HiraginoSans-W6", size: 14))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.textPrimary)
        .background(Color(red: 0.91, green: 0.73, blue: 0.25))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .opacity(isEnabled ? 1 : 0.45)
        .disabled(!isEnabled)
    }
}

#Preview {
    ZStack {
        Color.textSecondary.ignoresSafeArea()
        DiaryActionBar(
            isEnabled: true,
            onAddWord: {},
            onAddGrammar: {}
        )
        .padding()
    }
}
