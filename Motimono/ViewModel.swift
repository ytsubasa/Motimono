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

        belongingsSiuations = [s1, s2]
    }

    
    
}
