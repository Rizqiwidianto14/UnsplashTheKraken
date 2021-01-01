//
//  ImageModel.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import Foundation

//typealias imageArray = [Images]

struct Images: Decodable{
    let results: [Image]
    
}
struct Image: Decodable {
    let id: String
    let urls: URLS
}

struct URLS: Decodable {
    let full: URL
    let regular: URL
    let small: URL
}
