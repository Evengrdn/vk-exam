//
//  NetworkManager.swift
//  vk-exam
//
//  Created by Maksim Kuznecov on 20.10.2023.
//

import Foundation
import UIKit


enum GIFApiEndpoints: String {
    case tranding = "/gifs/trending"
}

enum NetworkPath: String {
    case giphy = "https://api.giphy.com/v1"
    
    var asURL: URL? {
        return URL(string: self.rawValue)
    }
}

struct GyphyGifResult: Decodable {
    var data: [GyphyGif]
}

struct GyphyGifImage: Decodable {
    
    struct Original: Decodable {
        let url: String
    }
    struct DownsizedSmall: Decodable {
        let url: String
    }
    
    let original: Original
    let downSized: DownsizedSmall
    
    enum CodingKeys: String, CodingKey {
        case original
        case downSized = "fixed_height"
    }
}

struct GyphyGif: Decodable {
    let id: String
    let title: String
    let url: String
    let slug: String
    let bitly_gif_url: String
    let bitly_url: String
    let embed_url: String
    var images: GyphyGifImage
}

protocol GyphyNetwork {
    
    /// Запрос картинок
    /// - Parameter urls: Массив ссылок на картинки
    /// - Returns: Массив оберток с относительными путями до картинок в кеше
    func fetchImages(batch: Int, offset: Int) async throws -> GyphyGifResult
    
}

final class NetworkManager: GyphyNetwork {
        
    func fetchImages(batch: Int, offset: Int = 0) async throws -> GyphyGifResult {
        // Осознано оставляю так, для улучшения надо выносить настройку урла
        // Переносить ключ в плист, для удобной замены
        // Создавать общий метод декода на джинерике
        var url = URL(string: NetworkPath.giphy.rawValue)!
        url.append(path: GIFApiEndpoints.tranding.rawValue)
        url.append(queryItems: [
            .init(name: "api_key", value: "SH28IW0a8EfyaKD5xp6kSA8v9ETS8Ryd"),
            .init(name: "limit", value: "\(batch)"),
            .init(name: "offset", value: "\(offset)")
        ])
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(GyphyGifResult.self, from: data)
        
        return result
    }
}
