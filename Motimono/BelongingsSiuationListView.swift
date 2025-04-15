//
//  BelongingsSiuation ListView.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import SwiftUI

struct BelongingsSiuationListView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.4)
                    .ignoresSafeArea()

                List {
                    ForEach(viewModel.belongingsSiuations, id: \.id) { situation in
                        NavigationLink {
                          
                            BelongingsSituationDetailView(situation: situation)

                        } label: {
                            BelongingsSiuationSignboard(
                                title: situation.title,
                                preparedCount: situation.ListBelongings.filter { $0.isPrepared }.count,
                                totalCount: situation.ListBelongings.count,
                                lastCompletedAt: situation.lastCompletedAt
                            )
                          
                        }
                      
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
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
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isPresentingAddView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .padding(.bottom, 20)
                        .padding(.trailing, 20)
                    }
                }
                .ignoresSafeArea()
                
            }
            .navigationTitle("状況別持ち物")
        }
        .onAppear{
            
            viewModel.loadMockData()
        }
        .sheet(isPresented: $viewModel.isPresentingAddView) {
            BelongingsSiuationAddView()
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
            
        }
    }
}



#Preview {
    BelongingsSiuationListView()
}
