//
//  BelongingsSituationDetailView.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import SwiftUI
import RealmSwift


struct BelongingsSituationDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    
    let situation: BelongingsSituation
    
    
    @State private var sortedBelongings: [Belongings] = []

    var preparedCount: Int {
        situation.ListBelongings.filter { $0.isPrepared }.count
    }

    var totalCount: Int {
        situation.ListBelongings.count
    }

    var body: some View {
        VStack(spacing: 0) {
           
            
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
                                    Button("削除",systemImage: "trash") {
                                        // 編集処理（モーダル表示・画面遷移など）
                                    }
                                    .tint(.red)
                                    
                                    Button("編集",systemImage: "pencil") {
                                        // 編集処理（モーダル表示・画面遷移など）
                                    }
                                    .tint(.blue)
                                    
                                }
                                
                                
                            }
                            .onMove(perform: moveBelongings)
                        }
                        .listStyle(.plain)
                        
                        
                        Spacer()
                    }
               
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.isPresentingBelongingsAddView = true
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
                
            }

          
           
        }
        .onAppear {
                  sortedBelongings = situation.ListBelongings.sorted(by: { $0.order < $1.order })
              }
        .navigationTitle(situation.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isPresentingBelongingsAddView) {
            BelongingsAddView(situation:self.situation)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
            
        }
    }
    
    
    func moveBelongings(from source: IndexSet, to destination: Int) {
           sortedBelongings.move(fromOffsets: source, toOffset: destination)

           do {
               let realm = try Realm()
               try realm.write {
                   for (index, item) in sortedBelongings.enumerated() {
                       item.order = index
                   }

                   // RealmのListに並び替えを反映（順番も）
                   situation.ListBelongings.removeAll()
                   situation.ListBelongings.append(objectsIn: sortedBelongings)
               }
           } catch {
               print("並び替え保存失敗: \(error.localizedDescription)")
           }
       }
    
    
}
