//
//  BelongingsBelongingsAddView.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//
import Foundation
import SwiftUI

struct BelongingsAddView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let situation: BelongingsSituation

    @State private var newText: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            // 角丸付きテキストフィールド
            TextField("持ち物を入力", text: $newText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .focused($isFocused)
                .padding(.horizontal)

            let isDisabled = newText.trimmingCharacters(in: .whitespaces).isEmpty

            Button(action: {
                guard !newText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                viewModel.addBelonging(to: situation, name: newText)
                  newText = ""
                  viewModel.isPresentingBelongingsAddView = false
            }) {
                Text("追加")
                    .font(.headline)
                    .foregroundColor(isDisabled ? Color.white.opacity(0.4) : Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isDisabled ? Color.gray.opacity(0.6) : Color.yellow)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .disabled(isDisabled)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
        .onAppear {
            isFocused = true
        }
    }
}
