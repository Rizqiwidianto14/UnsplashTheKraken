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
    var images: [Image] = []
    var fetchedImages: [Image] = []
    var cellViewModels: [CellViewModel] = []
    var fetchingMore = false
    var firstState = Int()
    
    var reloadIndicator = false
    
    
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
            let endpoint = UnsplashEndpoint.images(id: Client.apiKey, query: Client.query, page: Client.page)
            client.fetch(with: endpoint) { (condition) in
                switch condition {
                case .success(let photos):
                    print("fetchingmore = \(self.fetchingMore)")
                    self.images = photos.results
                    self.fetchPhoto()
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    
    func fetchMorePhotos(){
        if let client = client as? Client {
            self.isLoading = true
            let endpoint = UnsplashEndpoint.images(id: Client.apiKey, query: Client.query, page: Client.page)
            client.fetch(with: endpoint) { (condition) in
                switch condition {
                case .success(let photos):
                    self.fetchedImages = photos.results
                    self.images.append(contentsOf: photos.results)
                    self.reloadIndicator = true
                    self.fetchPhoto()
                    self.reloadIndicator = false
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    
    
    private func fetchPhoto() {
        //images di remove, append lagi
        let group = DispatchGroup()
        if reloadIndicator {
            self.fetchedImages.forEach { (photo) in
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
                self.fetchedImages.removeAll()
            }
        } else {
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

}
