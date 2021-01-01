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
    var cellViewModels: [CellViewModel] = []
    var fetchingMore = false
    var firstState = Int()
    
    
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
            print("fetchphotos")
            let endpoint = UnsplashEndpoint.images(id: Client.apiKey, query: Client.query, page: Client.page)
            client.fetch(with: endpoint) { (condition) in
                switch condition {
                case .success(let photos):
                    self.images = photos.results
                    self.fetchPhoto()
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    
    
    private func fetchPhoto() {
        print("fetchingphotos")
        //images di remove, append lagi
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
        self.images.removeAll()
    }

}
