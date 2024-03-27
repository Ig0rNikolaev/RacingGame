//
//  ImageStorage.swift
//  RacingGame
//
//  Created by Игорь Николаев on 09.03.2024.
//

import UIKit

private extension String {
    static let fileName = "avatar"
}

private extension CGFloat {
    static let compressionQuality = 1.0
}

protocol IImageStorage {
    func loadImage(by name: String) -> UIImage?
    func saveImage(image: UIImage) throws -> String?
}

final class ImageStorage: IImageStorage {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func saveImage(image: UIImage) throws -> String? {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: .compressionQuality) else { return nil }
        let name: String = .fileName
        let url = directory.appendingPathComponent(name)

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(atPath: url.path)
        }
        try data.write(to: url)
        return name
    }

    func loadImage(by name: String) -> UIImage? {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else  { return nil }
        let url = directory.appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
}
