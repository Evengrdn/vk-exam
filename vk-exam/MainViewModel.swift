//
//  MainViewModel.swift
//  vk-exam
//
//  Created by Maksim Kuznecov on 20.10.2023.
//

import Foundation
import UIKit


struct Gifs: Hashable {

    let id: UUID = UUID()
    
    let gifOne: GyphyGif
    
    let gifTwo: GyphyGif?
    
    static func == (lhs: Gifs, rhs: Gifs) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class MainViewModel {
        
    var images: [Gifs] = []
    
    /// Менеджер для работы с сетью
    let networkManager: GyphyNetwork = NetworkManager()
    
    /// Запрос картинок
    func fetchImages() async {
        do {
            let localImages = try await networkManager.fetchImages(batch: 30, offset: 0)
            images = appendGifToArray(gifs: localImages.data)
        }catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    /// Запрос картинок
    func fetchMore(offset: Int) async {
        do {
            let localImages = try await networkManager.fetchImages(batch: 30, offset: offset)
            let gifs =  appendGifToArray(gifs: localImages.data)
            images.append(contentsOf: gifs)
        }catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    /// Метод обработки данных для ячеек по 2 гифки
    /// - Parameter gifs: Гифки
    /// - Returns: Обертки готовые для показа в ячейках
    private func appendGifToArray(gifs: [GyphyGif]) -> [Gifs] {
        var gifsWrapp: [Gifs] = []
        var tmp: GyphyGif? = nil
        
        for gif in gifs {
            if tmp == nil {
                tmp = gif
                continue
            } else {
                gifsWrapp.append(.init(gifOne: tmp!, gifTwo: gif))
                tmp = nil
            }
        }
        
        if tmp != nil {
            gifsWrapp.append(.init(gifOne: tmp!, gifTwo: nil))
        }
        
        return gifsWrapp
    }
}
