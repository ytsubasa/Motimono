//
//  MotimonoApp.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/14.
//

import SwiftUI




@main
struct MotimonoApp: App {
    @State private var showSplash = true
    
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            if showSplash {
                appStartView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(viewModel) // ← ここで注入
            }
        }
    }
}
