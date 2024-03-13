//
//  RecordPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 17.03.2024.
//

import Foundation

protocol IRecordPresenter {
    func updateRecords()
    func arrayRecords() -> [Int]
}

final class RecordPresenter: IRecordPresenter {
    //: MARK: - Properties
    
    private var records: [Int] = []
    private let localStorage: ILocalStorage
    weak var view: IRecordView?
    
    //: MARK: - Initializers
    
    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }
    
    //: MARK: - Setups
    
    func arrayRecords() -> [Int] {
        records
    }
    
    func updateRecords() {
        let userRecords = localStorage.fetchValue(type: UserSetting.self)
        records = userRecords?.records?.sorted(by: >) ?? []
        view?.updateRecordTabel()
    }
}
