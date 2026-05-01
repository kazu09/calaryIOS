//
//  GrammarView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct GrammarView: View {
    @State private var isShowingDetail = false
    
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
                        onGrammarCardTap: {
                            isShowingDetail = true
                        }
                    )
                    .padding(16)
                    .sheet(isPresented: $isShowingDetail) {
                        Text("ハーフモーダルの中身")
                            .presentationDetents([.medium])
                    }
                    Spacer()
                }
            }
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    GrammarView()
}
