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

//
//enum Query: String{
//    case Jakarta, London, Office
//}


enum UnsplashEndpoint: EndPoint {
    case images(id: String, query: String)

    var baseUrl: String {
        return Client.baseUrl
    }


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
                URLQueryItem(name: "query", value: query)
            ]
        }
    }
}
