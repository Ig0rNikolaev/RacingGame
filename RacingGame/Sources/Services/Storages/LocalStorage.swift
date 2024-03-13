//
//  LocalStorage.swift
//  RacingGame
//
//  Created by Игорь Николаев on 06.03.2024.
//

import Foundation

private extension String {
    static let key = "user"
}

protocol ILocalStorage {
    func save<T: Codable>(_ value: T)
    func fetchValue<T: Codable>(type: T.Type) -> T?
}

final class LocalStorage: ILocalStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func save<T: Codable>(_ value: T) {
        let data = try? JSONEncoder().encode(value)
        userDefaults.set(data, forKey: .key)
    }

    func fetchValue<T: Codable>(type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: .key) else { return nil }
        let setting = try? JSONDecoder().decode(type, from: data)
        return setting
    }
}
