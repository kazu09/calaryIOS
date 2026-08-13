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
                    Label("debug.database.dump.action", systemImage: "terminal")
                }
            } header: {
                Text("debug.database.section.title")
            } footer: {
                Text("debug.database.section.footer")
            }
        }
        .navigationTitle("debug.title")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            viewModel.alertTitle,
            isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { if !$0 { viewModel.alertMessage = nil } }
            )
        ) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
}
#endif
