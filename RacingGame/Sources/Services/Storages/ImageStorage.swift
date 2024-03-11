//
//  ImageStorage.swift
//  RacingGame
//
//  Created by Игорь Николаев on 09.03.2024.
//

import UIKit

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
              let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let name = UUID().uuidString
        let url = directory.appendingPathComponent(name)
        try data.write(to: url)
        return name
    }
    
    func loadImage(by name: String) -> UIImage? {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else  { return nil }
        let url = directory.appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
}
