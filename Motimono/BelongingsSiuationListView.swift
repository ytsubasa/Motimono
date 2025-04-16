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
                    ForEach(Array(viewModel.belongingsSiuations.enumerated()), id: \.element.id) { index, situation in
                        NavigationLink {
                          
                            BelongingsSituationDetailView(situation: situation)

                        } label: {
                            BelongingsSiuationSignboard(
                                title: situation.title,
                                preparedCount: situation.ListBelongings.filter { $0.isPrepared }.count,
                                totalCount: situation.ListBelongings.count,
                                lastCompletedAt: situation.lastCompletedAt
                            )
                            .opacity(viewModel.hasAppeared ? 1 : 0)
                            .offset(y: viewModel.hasAppeared ? 0 : 30)
                            .animation(.spring().delay(Double(index) * 0.07), value: viewModel.hasAppeared)
                            
                        }
                     
                      
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .swipeActions(edge: .trailing) {
                            Button("削除",systemImage: "trash") {
                                viewModel.deleteBelongingsSituation(situation)
                            }
                            .tint(.red)
                            
                            Button("編集",systemImage: "pencil") {
                                // 編集処理（モーダル表示・画面遷移など）
                            }
                            .tint(.blue)
                            
                        }
                     
                        
                        
                    }
                    .onMove(perform: viewModel.moveBelongingsSituation)
                }
                
                .listStyle(.plain)
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isPresentingSituationAddView = true
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
            
            DispatchQueue.main.async {
                   viewModel.hasAppeared = true
               }
        }
        .sheet(isPresented: $viewModel.isPresentingSituationAddView) {
            BelongingsSiuationAddView()
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
            
        }
    }
}



#Preview {
    BelongingsSiuationListView()
}
