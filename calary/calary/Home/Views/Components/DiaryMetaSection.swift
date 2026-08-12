//
//  DiaryMetaSection.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import SwiftUI

struct DiaryMetaSection: View {
    @Binding var entryDate: Date
    @Binding var selectedTag: String?
    let diaryTags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            DatePicker(
                "日付",
                selection: $entryDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .font(.custom("HiraginoSans-W6", size: 15))
            .tint(.textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if !diaryTags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("日記タグ")
                        .font(.custom("HiraginoSans-W6", size: 16))
                        .foregroundStyle(.white)
                    
                    Picker("日記タグ", selection: $selectedTag) {
                        Text("タグなし").tag(nil as String?)
                        ForEach(diaryTags, id: \.self) { tag in
                            Text(tag).tag(tag as String?)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.textPrimary)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
        }
    }
}

struct DiaryQuestionSection: View {
    @Binding var teacherQuestion: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("先生への質問")
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundStyle(.white)
            
            ZStack(alignment: .topLeading) {
                if teacherQuestion.isEmpty {
                    Text("先生に確認したいことがあれば入力してください")
                        .font(.custom("HiraginoSans-W3", size: 15))
                        .foregroundStyle(.textMuted)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $teacherQuestion)
                    .font(.custom("HiraginoSans-W3", size: 15))
                    .foregroundStyle(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .frame(minHeight: 120)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ZStack {
        Color.textSecondary.ignoresSafeArea()
        DiaryMetaSection(
            entryDate: .constant(.now),
            selectedTag: .constant(nil),
            diaryTags: ["授業", "自習"]
        )
        .padding()
    }
}
