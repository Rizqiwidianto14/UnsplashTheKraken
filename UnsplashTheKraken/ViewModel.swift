//
//  ViewModel.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 30/12/20.
//

import UIKit

struct CellViewModel {
    let image: UIImage
}

class ViewModel {
    private let client: ApiService
    private var images: [Image] = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    var cellViewModels: [CellViewModel] = []
    
    
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
    init(client: ApiService) {
        self.client = client
    }
    
    
    
    func fetchPhotos() {
        if let client = client as? Client {
            self.isLoading = true
            
            let endpoint = UnsplashEndpoint.images(id: Client.apiKey, query: Client.query)
            print(Client.query)
            client.fetch(with: endpoint) { (condition) in
                switch condition {
                case .success(let photos):
                    self.images = photos.results
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    
    
    private func fetchPhoto() {
        let group = DispatchGroup()
        self.images.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                guard let imageData = try? Data(contentsOf: photo.urls.small) else {
                    self.showError?(APIError.errorWhenDownloadingImage)
                    return
                }

                guard let image = UIImage(data: imageData) else {
                    self.showError?(APIError.errorWhenConvertingImage)
                    return
                }

                self.cellViewModels.append(CellViewModel(image: image))
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
    }

}
