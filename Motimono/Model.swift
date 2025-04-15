//
//  Model.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import RealmSwift


class BelongingsSituation:Object, Identifiable{
    
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate() // 🔑自動生成されるID
    @Persisted var title: String = ""
    @Persisted var ListBelongings: List<Belongings>
    @Persisted var lastCompletedAt: Date?
    @Persisted var order: Int

    
}



class Belongings:Object, Identifiable{
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var name: String
    @Persisted var isPrepared: Bool = false
    @Persisted var order: Int

}

  
