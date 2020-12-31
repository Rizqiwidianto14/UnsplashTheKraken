//
//  ViewController.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 29/12/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let viewModel = ViewModel(client: Client())


    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? CollectionViewLayout{
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.showError = { error in
            print(error)
        }
        viewModel.reloadData = {
            self.collectionView.reloadData()

        }
        viewModel.fetchPhotos()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

}


extension ViewController: CollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.cellViewModels[indexPath.item].image
        let height = image.size.height / 2
        return height
    }
    

}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("jumlah view model = \(viewModel.cellViewModels.count) || jumlah images = \(viewModel.images.count)")
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let image = viewModel.cellViewModels[indexPath.item].image
        cell.imageView.image = image
        return cell
    }
    
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.firstState = 0
        Client.query = searchBar.text ?? "Jakarta"
        viewModel.cellViewModels.removeAll()
        viewModel.showError = { error in
            print(error)
        }
        viewModel.fetchPhotos()
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }

    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        if offsetY > contentHeight - frameHeight - 200{
            if viewModel.firstState == 1 {
                if !viewModel.fetchingMore{
                    beginReloadViaScrollView()
                }

            }
            
            viewModel.firstState = 1




        }
    }
    
    func beginReloadViaScrollView(){
        viewModel.fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
            Client.pageNumber += 1
            Client.page = "\(Client.pageNumber)"
            self.viewModel.showError = { error in
                print(error)
            }
            self.viewModel.fetchNewPhotos()
            self.viewModel.reloadData = {
                self.collectionView.reloadData()
            }
            self.viewModel.fetchingMore = false

        }
    }

    
    
}
