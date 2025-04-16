//
//  ViewModel.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import RealmSwift



class ViewModel: ObservableObject {
    
    @Published var hasAppeared = false

   
    
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
              
              print("📥 起動時の並び順確認:")
                     for item in belongingsSiuations {
                         print("・\(item.title) → order: \(item.order)")
                     }

              
          } catch {
              print("フェッチ失敗: \(error.localizedDescription)")
              belongingsSiuations = []
          }
      }

    
    
    
    
    
    // MARK: - 持ち物状況追加ビュー処理
    
    
    @Published var isPresentingSituationAddView: Bool = false
    
    
    
    // MARK: - 状況追加処理
    
    
    
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
    
    
    // MARK: - 持ち物追加ビュー処理
    
    
    @Published var isPresentingBelongingsAddView: Bool = false
    
    
    
    // MARK: - 持ち物追加処理
    
    
    func addBelonging(to situation: BelongingsSituation, name: String) {
        let newBelonging = Belongings()
        newBelonging.name = name
        newBelonging.order = situation.ListBelongings.count

        do {
            let realm = try Realm()
            try realm.write {
                situation.ListBelongings.append(newBelonging)
            }
        } catch {
            print("持ち物の追加に失敗: \(error.localizedDescription)")
        }
    }

    
    


    
    // MARK: - 状況削除処理
    
    func deleteBelongingsSituation(_ situation: BelongingsSituation) {
        let deletedId = situation.id
        let deletedTitle = situation.title
        
        let updatedArray = belongingsSiuations.filter { $0.id != deletedId }
        
        belongingsSiuations = updatedArray
        
        print("🗑️ 削除リクエスト: \(deletedTitle) (id: \(deletedId))")
        print("✅ Realmから削除完了: \(deletedTitle) (id: \(deletedId))")
        
        print("📋 削除後の一覧:")
        for item in belongingsSiuations {
            print("・\(item.title) → order: \(item.order), id: \(item.id)")
        }
        
        let delay = 0.5
        
        /// ビュー側の参照切れを待ってから Realm オブジェクトを削除（直後だとクラッシュするため）

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            do {
                let realm = try Realm()
                
                guard let managed = realm.object(ofType: BelongingsSituation.self, forPrimaryKey: deletedId) else {
                    print("⚠️ 対象が Realm に存在しない")
                    return
                }
                
                
                try realm.write {
                    realm.delete(managed)
                }
                
            } catch {
                print("❌ 削除失敗: \(error.localizedDescription)")
            }
            
        }
    }



    
    
    // MARK: - 状況別持ち物モデル並べ替え処理
    
    func moveBelongingsSituation(from source: IndexSet, to destination: Int) {
        belongingsSiuations.move(fromOffsets: source, toOffset: destination)

        do {
            let realm = try Realm()
            try realm.write {
                for (index, item) in belongingsSiuations.enumerated() {
                    item.order = index
                }
            }

            // 🔽 並び順ログ出力
            print("📦 並び替え結果（タイトルとorder）:")
            for item in belongingsSiuations {
                print("・\(item.title) → order: \(item.order)")
            }

        } catch {
            print("順番保存失敗: \(error.localizedDescription)")
        }
    }


    
    
    
    func loadMockData() {
//        let b1 = Belongings()
//        b1.name = "財布"
//        b1.isPrepared = true
//        b1.order = 0
//
//        let b2 = Belongings()
//        b2.name = "鍵"
//        b2.isPrepared = false
//        b2.order = 1
//
//        let b3 = Belongings()
//        b3.name = "スマホ"
//        b3.isPrepared = true
//        b3.order = 0
//
//        let b4 = Belongings()
//        b4.name = "ハンカチ"
//        b4.isPrepared = true
//        b4.order = 1
//
//        let list1 = List<Belongings>()
//        list1.append(objectsIn: [b1, b2])
//
//        let list2 = List<Belongings>()
//        list2.append(objectsIn: [b3, b4])
//
//        let s1 = BelongingsSituation()
//        s1.title = "出勤前チェック"
//        s1.ListBelongings = list1
//        s1.lastCompletedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // 昨日
//        s1.order = 0
//
//        let s2 = BelongingsSituation()
//        s2.title = "旅行準備"
//        s2.ListBelongings = list2
//        s2.lastCompletedAt = Date() // 今日
//        s2.order = 1
//
//        belongingsSiuations.append(s1)
//        belongingsSiuations.append(s2)
    }

    
    
}
