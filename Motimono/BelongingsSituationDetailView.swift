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

    var preparedCount: Int {
        situation.ListBelongings.filter { $0.isPrepared }.count
    }

    var totalCount: Int {
        situation.ListBelongings.count
    }

    var body: some View {
        VStack(spacing: 0) {
            // 上部に黄色の丸とカウントテキスト
            
            
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width  , height: geometry.size.height)
                    
                   
                .padding(.top, 16)
                .offset( y: -geometry.size.height * 0.74 )
                    
                    
                    VStack(spacing: 4) {
                        Text("\(preparedCount)/\(totalCount)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom,8)
                        
                        
                        
                        List {
                            ForEach(situation.ListBelongings, id: \.id) { item in
                                HStack {
                                    Image(systemName: item.isPrepared ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isPrepared ? .green : .gray)

                                    Text(item.name)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("削除") {
                                        // 編集処理（モーダル表示・画面遷移など）
                                    }
                                    .tint(.red)
                                    
                                    Button("編集") {
                                        // 編集処理（モーダル表示・画面遷移など）
                                    }
                                    .tint(.blue)
                                    
                                }
                                
                                
                            }
                        }
                        .listStyle(.plain)
                        
                        
                        Spacer()
                    }
               
                    
                    
                    
                }
                
            }

            // リスト本体
          
            
           
        }
        .navigationTitle(situation.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
