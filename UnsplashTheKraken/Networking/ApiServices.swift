//
//  WebServices.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import Foundation

enum APIError: Error {
    case badRequestResponse, errorWhenDecoding, errorWhenDownloadingImage, errorWhenConvertingImage
}

protocol ApiService {
    var session: URLSession { get }
    func get<T: Codable>(with url: URLRequest, completion: @escaping (Conditions<[T]>) -> Void)
}

enum Conditions<T> {
    case success(T)
    case error(Error)
}

extension ApiService {

    var session: URLSession {
        return URLSession.shared
    }

    func get<T: Codable>(with url: URLRequest, completion: @escaping (Conditions<[T]>) -> Void) {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error{
                completion(.error(error))
                return
            }
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.error(APIError.badRequestResponse))
                return
            }
            guard let value = try? JSONDecoder().decode([T].self, from: data!) else {
                completion(.error(APIError.errorWhenDecoding))
                return
            }
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
}

