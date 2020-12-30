//
//  EndPoint.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import Foundation

protocol EndPoint {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
}

extension EndPoint{
    var urlComponent: URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = parameters
        
        return urlComponent!
    }
    var urlRequest: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
    
}


enum Query: String{
    case Jakarta, London
}


enum UnsplashEndpoint: EndPoint {
    case images(id: String, query: Query)

    var baseUrl: String {
        return Client.baseUrl
    }
    //    https://api.unsplash.com/search/photos?page=1&query=jakarta&client_id=VXW1shYNLxyVT0_bJ9NW7lg1BiPECg1UYYsRmgTDm9o

    var path: String {
        switch self {
        case .images:
            return "/search/photos"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .images(let id, let query):
            return [
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "query", value: query.rawValue)
            ]
        }
    }
}
