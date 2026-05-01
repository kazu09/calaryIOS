//
//  SettingsRowView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct SettingsRowView: View {
    let systemImageName: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.95))
                    .frame(width: 42, height: 42)

                Image(systemName: systemImageName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textSecondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("HiraginoSans-W6", size: 15))
                    .foregroundStyle(.textPrimary)

                Text(description)
                    .font(.custom("HiraginoSans-W3", size: 12))
                    .foregroundStyle(.textMuted)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.textMuted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    SettingsRowView(
        systemImageName: "bell.badge",
        title: "通知設定",
        description: "通知を受け取る時間や種類を変更できます。"
    )
    .padding()
    .background(Color.backgroundPrimary)
}
