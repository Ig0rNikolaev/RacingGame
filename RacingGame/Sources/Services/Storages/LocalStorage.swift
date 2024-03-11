//
//  LocalStorage.swift
//  RacingGame
//
//  Created by Игорь Николаев on 06.03.2024.
//

import Foundation

protocol ILocalStorage {
    func save<T>(_ value: T, for key: String)
    func fetchValue<T: Codable>(type: T.Type, for key: String) -> T?
}

final class LocalStorage: ILocalStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func save<T>(_ value: T, for key: String) {
        userDefaults.set(value, forKey: key)
    }

    func fetchValue<T: Codable>(type: T.Type, for key: String) -> T? {
        var user: T?
        if let data = userDefaults.value(forKey: key) as? Data {
            user = try? JSONDecoder().decode(type, from: data)
        }
        return user
    }
}
