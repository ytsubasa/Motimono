//
//  MotimonoApp.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/14.
//

import SwiftUI

@main
struct MotimonoApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel) // ← ここで注入
        }
    }
}
