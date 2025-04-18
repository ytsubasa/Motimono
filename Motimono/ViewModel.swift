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

        //  初回のみサンプルデータ登録
        if !UserDefaults.standard.bool(forKey: "didInsertInitialData") {
            loadSampleData()
            UserDefaults.standard.set(true, forKey: "didInsertInitialData")
        }

       
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
    
    
    
    
    
    // MARK: -  編集状況保持
    
    @Published var editingSituation: BelongingsSituation?

    
    
    
    
    // MARK: - 状況追加処理
    
    
    
    func addBelongingsSituation(title: String, editingItem: BelongingsSituation? = nil) {
        do {
            let realm = try Realm()

            if let item = editingItem {
                // ✅ 編集処理
                try realm.write {
                    item.title = title
                }

                // ✅ 表示配列を更新
                if let index = belongingsSiuations.firstIndex(where: { $0.id == item.id }) {
                    belongingsSiuations[index] = item
                    print("✏️ 編集完了: \(title) (id: \(item.id))")
                }

            } else {
                // ✅ 新規追加処理
                let newSituation = BelongingsSituation()
                newSituation.title = title
                newSituation.order = belongingsSiuations.count
                newSituation.ListBelongings = List<Belongings>()
                newSituation.lastCompletedAt = nil

                try realm.write {
                    realm.add(newSituation)
                }

                belongingsSiuations.append(newSituation)
                print("🆕 追加完了: \(title) (id: \(newSituation.id))")
            }

        } catch {
            print("❌ 追加・編集失敗: \(error.localizedDescription)")
        }
    }

    
    
    // MARK: - 持ち物追加ビュー処理
    
    
    @Published var isPresentingBelongingsAddView: Bool = false
    
    
    
    
    // MARK: -  編集持ち物
    
    @Published var editingBelongings: Belongings?
    
    
    // MARK: - 持ち物追加処理
    
    
    func addBelonging(
        to situation: BelongingsSituation,
        name: String,
        editingItem: Belongings? = nil,
        parent: BelongingsSituation
    ) {
        do {
            let realm = try Realm()

            if let editingItem = editingItem {
                // ✅ 編集処理
                guard let managedBelonging = realm.object(ofType: Belongings.self, forPrimaryKey: editingItem.id) else {
                    print("⚠️ 編集対象が Realm に存在しません")
                    return
                }

                try realm.write {
                    managedBelonging.name = name
                }

                print("✏️ 持ち物の名前を更新しました: \(name) (id: \(managedBelonging.id))")

            } else {
                // ✅ 新規追加処理
                let newBelonging = Belongings()
                newBelonging.name = name
                newBelonging.order = situation.ListBelongings.count

                try realm.write {
                    situation.ListBelongings.append(newBelonging)
                }

                print("🆕 持ち物を追加しました: \(name) (id: \(newBelonging.id))")
            }

            // ✅ UI更新用: belongingsSiuationsを更新
            if let index = belongingsSiuations.firstIndex(where: { $0.id == parent.id }) {
                belongingsSiuations[index] = parent // Realmで変更された参照を再代入
            }

        } catch {
            print("❌ 持ち物の追加・編集に失敗: \(error.localizedDescription)")
        }
    }


    
    
    
    // MARK: - 持ち物削除処理
    
    
    func deleteBelonging(_ belonging: Belongings, from situation: BelongingsSituation) -> [Belongings] {
        let deletedId = belonging.id
        let deletedName = belonging.name

        do {
            let realm = try Realm()

            // Realmから管理中の最新オブジェクトを取得
            guard let managedSituation = realm.object(ofType: BelongingsSituation.self, forPrimaryKey: situation.id),
                  let managedBelonging = realm.object(ofType: Belongings.self, forPrimaryKey: deletedId) else {
                print("⚠️ 対象が見つかりません")
                return situation.ListBelongings.sorted(by: { $0.order < $1.order })
            }

            // ✅ リストから対象を削除
            if let index = managedSituation.ListBelongings.firstIndex(where: { $0.id == deletedId }) {
                try realm.write {
                    managedSituation.ListBelongings.remove(at: index)
                }
            }

            // ✅ belongingsSiuations の該当要素も再代入（UI更新）
            if let index = belongingsSiuations.firstIndex(where: { $0.id == situation.id }) {
                belongingsSiuations[index] = managedSituation
            }

            // ✅ Realm本体からの削除を0.5秒遅延してクラッシュ防止
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                do {
                    let realm = try Realm()
                    if let toDelete = realm.object(ofType: Belongings.self, forPrimaryKey: deletedId) {
                        try realm.write {
                            realm.delete(toDelete)
                        }
                        print("🗑️ 削除完了（遅延後）: \(deletedName) (id: \(deletedId))")
                    }
                } catch {
                    print("❌ 遅延削除失敗: \(error.localizedDescription)")
                }
            }

            // ✅ UI表示用にソート済み配列を返す
            return managedSituation.ListBelongings.sorted(by: { $0.order < $1.order })

        } catch {
            print("❌ 削除前処理失敗: \(error.localizedDescription)")
            return situation.ListBelongings.sorted(by: { $0.order < $1.order })
        }
    }



    
    
    
    
    // MARK: - 持ち物k準備完了トグル処理
    
    
    
    
    func togglePrepared(for belonging: Belongings, in situation: BelongingsSituation) -> [Belongings] {
        do {
            let realm = try Realm()

            guard let managed = realm.object(ofType: Belongings.self, forPrimaryKey: belonging.id) else {
                print("⚠️ 対象が Realm に存在しない")
                return situation.ListBelongings.sorted(by: { $0.order < $1.order }).map { $0 }
            }

            try realm.write {
                managed.isPrepared.toggle()
            }

            print("🔁 トグル完了: \(managed.name) → isPrepared: \(managed.isPrepared)")

            // ✅ SwiftUI UI更新のため、該当のBelongingsSituationを再代入
            if let index = belongingsSiuations.firstIndex(where: { $0.id == situation.id }) {
                belongingsSiuations[index] = situation
            }

            // ✅ 再描画用にソートした配列を返す（コピーで参照切り離し）
            return situation.ListBelongings.sorted(by: { $0.order < $1.order }).map { $0 }

        } catch {
            print("❌ トグル失敗: \(error.localizedDescription)")
            return situation.ListBelongings.sorted(by: { $0.order < $1.order }).map { $0 }
        }
    }



    
    
    // MARK: - 持ち物全完了処理
    
    func completeAndResetBelongings(for situation: BelongingsSituation) {
        do {
            let realm = try Realm()

            // 対象の Realm オブジェクトを取得
            guard let managed = realm.object(ofType: BelongingsSituation.self, forPrimaryKey: situation.id) else {
                print("⚠️ 指定の持ち物状況が見つかりません")
                return
            }

            try realm.write {
                // 1️⃣ 完了時間を記録
                managed.lastCompletedAt = Date()

                // 2️⃣ 全ての isPrepared を false にリセット
                for belonging in managed.ListBelongings {
                    belonging.isPrepared = false
                }
            }

            print("✅ 完了処理とリセット完了：\(managed.title)")

            // 3️⃣ SwiftUIの配列も更新
            if let index = belongingsSiuations.firstIndex(where: { $0.id == situation.id }) {
                belongingsSiuations[index] = managed
            }

        } catch {
            print("❌ 完了処理エラー: \(error.localizedDescription)")
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


    
    
    
    func loadSampleData() {
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
        b3.isPrepared = false
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
        s1.title = "出勤前"
        s1.ListBelongings = list1
        s1.lastCompletedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        s1.order = 0

        let s2 = BelongingsSituation()
        s2.title = "旅行準備"
        s2.ListBelongings = list2
        s2.lastCompletedAt = Date()
        s2.order = 1

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(s1)
                realm.add(s2)
            }
        } catch {
            print("❌ モックデータ保存失敗: \(error.localizedDescription)")
        }

        // 表示用のローカル配列にも追加（UI描画用）
        belongingsSiuations.append(contentsOf: [s1, s2])
    }


    
    
}
