//
//  HomeView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var cardDate = "April, 30"
    @State private var checkAnswer = "未回答"
    @State private var enTitle = "TitleTitleTitle"
    @State private var jaTitle = "タイトルタイトルタイトル"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        // 設定画面へ
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(.textSecondary)
                    }
                }
                .overlay {
                    Text("Calary")
                        .font(.system(size: 24))
                        .foregroundStyle(.textSecondary)
                        .bold()
                        .italic()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 18)
                
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.textPrimary)
                            .padding(.leading,12)
                            .padding(.trailing,4)
                    }
                    
                    Text("2026年4月")
                        .font(.system(size: 24))
                        .foregroundStyle(.textPrimary)
                        .bold()
                        .italic()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.textPrimary)
                            .padding(.leading,4)
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ScrollView {
                    VStack {
                        DiaryCardView(
                            cardDate: cardDate,
                            checkAnswer: checkAnswer,
                            enTitle: enTitle,
                            jaTitle: jaTitle
                        )
                    }
                    .padding(16)
                }
                Spacer()
            }
            
        }.background(Color.backgroundPrimary)
    }
}

#Preview {
    HomeView()
}
