//
//  ViewModel.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import RealmSwift



class ViewModel: ObservableObject {
   
    
    @Published var belongingsSiuations : [BelongingsSituation] = []
    
    
    
    init() {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                        // マイグレーション処理があればここに
                    }
                }
            )
            Realm.Configuration.defaultConfiguration = config

            fetchBelongingsSituations()
        }
    
    
    
    
    // MARK: - フェッチ処理
    
    
    func fetchBelongingsSituations() {
          do {
              let realm = try Realm()
              let results = realm.objects(BelongingsSituation.self).sorted(byKeyPath: "order", ascending: true)
              belongingsSiuations = Array(results)
          } catch {
              print("フェッチ失敗: \(error.localizedDescription)")
              belongingsSiuations = []
          }
      }

    
    
    
    
    
    // MARK: - 追加ビュー処理
    
    
    @Published var isPresentingAddView: Bool = false
    
    
    
    
    // MARK: - 追加処理
    
    func addBelongingsSituation(title: String) {
        let newSituation = BelongingsSituation()
        newSituation.title = title
        newSituation.order = belongingsSiuations.count
        newSituation.ListBelongings = List<Belongings>() // 空の初期値でもOK
        newSituation.lastCompletedAt = nil

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newSituation)
            }

            // 表示用にも配列に追加
            belongingsSiuations.append(newSituation)

        } catch {
            print("追加失敗: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    // MARK: - 状況別持ち物モデル並べ替え処理
    
    func moveBelongingsSituation(from source: IndexSet, to destination: Int) {
        belongingsSiuations.move(fromOffsets: source, toOffset: destination)

        // 並び順を Realm に保存（order を更新）
        do {
            let realm = try Realm()
            try realm.write {
                for (index, item) in belongingsSiuations.enumerated() {
                    item.order = index
                }
            }
        } catch {
            print("順番保存失敗: \(error.localizedDescription)")
        }
    }


    
    
    
    func loadMockData() {
        let b1 = Belongings()
        b1.name = "財布"
        b1.isPrepared = true
        b1.order = 0

        let b2 = Belongings()
        b2.name = "鍵"
        b2.isPrepared = false
        b2.order = 1

        let b3 = Belongings()
        b3.name = "スマホ"
        b3.isPrepared = true
        b3.order = 0

        let b4 = Belongings()
        b4.name = "ハンカチ"
        b4.isPrepared = true
        b4.order = 1

        let list1 = List<Belongings>()
        list1.append(objectsIn: [b1, b2])

        let list2 = List<Belongings>()
        list2.append(objectsIn: [b3, b4])

        let s1 = BelongingsSituation()
        s1.title = "出勤前チェック"
        s1.ListBelongings = list1
        s1.lastCompletedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // 昨日
        s1.order = 0

        let s2 = BelongingsSituation()
        s2.title = "旅行準備"
        s2.ListBelongings = list2
        s2.lastCompletedAt = Date() // 今日
        s2.order = 1

        belongingsSiuations.append(s1)
        belongingsSiuations.append(s2)
    }

    
    
}
