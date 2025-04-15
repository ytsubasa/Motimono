//
//  BelongingsSituationDetailView.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import SwiftUI


struct BelongingsSituationDetailView: View {
    let situation: BelongingsSituation

    var body: some View {
        List {
            ForEach(situation.ListBelongings, id: \.id) { item in
                HStack {
                    Image(systemName: item.isPrepared ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isPrepared ? .green : .gray)
                    
                    Text(item.name)
                }
            }
        }
        .navigationTitle(situation.title)
        .listStyle(.plain)
    }
}
