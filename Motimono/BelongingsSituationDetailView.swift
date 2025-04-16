//
//  BelongingsSituationDetailView.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import SwiftUI
import RealmSwift
import UIKit


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
    
    @State private var redrawTrigger = UUID()
    
    @State private var animateCheckmarkID: ObjectId? = nil
    
    @State private var showCompletionOverlay = false

    @Environment(\.dismiss) var dismiss



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
                            ForEach(sortedBelongings, id: \.id) { item in
                                HStack {
                                    Image(systemName: item.isPrepared ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isPrepared ? .green : .gray)
                                           .scaleEffect(animateCheckmarkID == item.id ? 1.5 : 1.0)
                                           .animation(.spring(response: 0.4, dampingFraction: 0.4), value: animateCheckmarkID)

                                    Text(item.name)
                                        .foregroundColor(item.isPrepared ? Color.gray.opacity(0.6) : .black)
                                         .strikethrough(item.isPrepared, color: .gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // ← 横いっぱいに
                                  .contentShape(Rectangle()) // ← ここで範囲確定
                                .onTapGesture {
                                    let wasPrepared = item.isPrepared
                                    
                                    sortedBelongings = viewModel.togglePrepared(for: item, in: situation)
                                    
                                    //完了から未完了へのトグル時はアニメーションさせない
                                    if !wasPrepared {
                                        animateCheckmarkID = item.id
                                        
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                             generator.impactOccurred()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            animateCheckmarkID = nil
                                        }
                                        
                                        
                                        //全て完了時の処理
                                        let allDone = sortedBelongings.allSatisfy { $0.isPrepared }
                                         if allDone {
                                             
                                             viewModel.completeAndResetBelongings(for: situation)
                                             
                                             let heavyGen = UIImpactFeedbackGenerator(style: .heavy)
                                             heavyGen.impactOccurred()
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                 heavyGen.impactOccurred()
                                             }

                                             // ✅ 成功アニメーション表示
                                             showCompletionOverlay = true

                                             // ✅ 1秒後に画面を閉じる
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                 dismiss()
                                             }
                                         }
                                        
                                        
                                    }
                                    
                                    redrawTrigger = UUID() // ← 再描画強制
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("削除",systemImage: "trash") {
                                        
                                        sortedBelongings = viewModel.deleteBelonging(item, from: situation)
                                    }
                                    .tint(.red)
                                    
                                    Button("編集",systemImage: "pencil") {
                                        viewModel.editingBelongings = item
                                        viewModel.isPresentingBelongingsAddView = true
                                    }
                                    .tint(.blue)
                                    
                                }
                                .id(redrawTrigger) // ← 各セルを UUID で再レンダリング
                                
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
        .overlay(
            ZStack {
                if showCompletionOverlay {
                    Color.black.opacity(0.4).ignoresSafeArea()

                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                            .transition(.scale.combined(with: .opacity))

                        Text("すべて完了！")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.opacity)
                }
            }
        )

        
        
        
        .onAppear {
                  sortedBelongings = situation.ListBelongings.sorted(by: { $0.order < $1.order })
              }
        .navigationTitle(situation.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isPresentingBelongingsAddView) {
            BelongingsAddView(situation:self.situation,editingItem: viewModel.editingBelongings)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
                .onDisappear {
                          // ✅ モーダルが閉じられたタイミングで編集状態をクリア
                    print("モーダルが閉じられました")
                          viewModel.editingBelongings = nil
                      }
            
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
