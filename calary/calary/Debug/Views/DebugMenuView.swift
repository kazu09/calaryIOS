//
//  DebugMenuView.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

#if DEBUG
import SwiftUI

struct DebugMenuView: View {
    @State private var viewModel: DebugMenuViewModel
    
    init(viewModel: DebugMenuViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                Button {
                    viewModel.dumpDatabaseToConsole()
                } label: {
                    Label("DBの中身をログ出力", systemImage: "terminal")
                }
            } header: {
                Text("データベース")
            } footer: {
                Text("SwiftDataに保存されている全データをXcodeコンソールへ出力します。")
            }
        }
        .navigationTitle("デバッグ")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            viewModel.alertTitle,
            isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { if !$0 { viewModel.alertMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
}
#endif
