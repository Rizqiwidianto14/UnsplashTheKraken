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

enum Order: String {
    case popular, latest, oldest
}

enum UnsplashEndpoint: EndPoint {
    case images(id: String, order: Order)

    var baseUrl: String {
        return Client.baseUrl
    }

    var path: String {
        switch self {
        case .images:
            return "/photos"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .images(let id, let order):
            return [
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "order_by", value: order.rawValue)
            ]
        }
    }
}
