//
//  Client.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import Foundation

class Client: ApiService {
    static let baseUrl = "https://api.unsplash.com"
    static let apiKey = "VXW1shYNLxyVT0_bJ9NW7lg1BiPECg1UYYsRmgTDm9o"
    static var query = "Jakarta"

    func fetch(with endpoint: UnsplashEndpoint, completion: @escaping (Conditions<Images>) -> Void) {
        let request = endpoint.urlRequest
        get(with: request, completion: completion)
    }
}
