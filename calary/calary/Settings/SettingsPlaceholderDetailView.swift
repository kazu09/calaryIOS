//
//  SettingsPlaceholderDetailView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct SettingsPlaceholderDetailView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Image(systemName: "gearshape.2")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.textSecondary)

                Text(title)
                    .font(.custom("HiraginoSans-W6", size: 20))
                    .foregroundStyle(.textPrimary)

                Text(description)
                    .font(.custom("HiraginoSans-W3", size: 14))
                    .foregroundStyle(.textMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 6)
            .padding(16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsPlaceholderDetailView(
            title: "JSONエクスポート",
            description: "ここに仮の詳細画面を表示します。"
        )
    }
}
