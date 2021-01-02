//
//  ImageModel.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import Foundation

struct Images: Decodable{
    let results: [Image]
    
}
struct Image: Decodable {
    let id: String
    let urls: URLS
}

struct URLS: Decodable {
    let small: URL
}
