//
//  ViewController.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 29/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    let viewModel = ViewModel(client: Client())
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageIndicator: UILabel!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var downloadingImages: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pageView.layer.cornerRadius = 5
        if let layout = collectionView.collectionViewLayout as? CollectionViewLayout{
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.indicatorView.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.indicatorView.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
        viewModel.showError = { error in
            print(error)
        }
        viewModel.reloadData = {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            
            
        }
        viewModel.fetchPhotos()
        pageIndicator.text = "Page: \(Client.pageNumber)"
        searchBar.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}


extension ViewController: CollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.cellViewModels[indexPath.row].image
        let height = image.size.height / 2
        return height
    }
    
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(viewModel.cellViewModels.count)
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let image = viewModel.cellViewModels[indexPath.row].image
        cell.imageView.image = image
        return cell
    }
    
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Client.query = searchBar.text ?? "Jakarta"
        Client.pageNumber = 1
        Client.page = "\(Client.pageNumber)"
        self.pageIndicator.text = "Page: \(Client.pageNumber)"
        viewModel.cellViewModels.removeAll()
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.indicatorView.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.indicatorView.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
        viewModel.showError = { error in
            print(error)
        }
        viewModel.fetchPhotos()
        self.viewModel.reloadData = {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            
        }
        
        
        
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func beginReloadViaScrollView() {
        viewModel.fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
            Client.pageNumber += 1
            Client.page = "\(Client.pageNumber)"
            self.pageIndicator.text = "Page: \(Client.pageNumber)"
            self.viewModel.cellViewModels.removeAll()
            self.viewModel.showLoading = {
                if self.viewModel.isLoading {
                    self.indicatorView.startAnimating()
                    self.collectionView.alpha = 0.0
                } else {
                    self.indicatorView.stopAnimating()
                    self.collectionView.alpha = 1.0
                }
            }
            self.viewModel.showError = { error in
                print(error)
            }
            self.viewModel.fetchPhotos()
            self.viewModel.reloadData = {
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                
            }
            self.viewModel.fetchingMore = false
            
        }
    }
    
    func beginReloadTop(){
        viewModel.fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
            Client.pageNumber -= 1
            Client.page = "\(Client.pageNumber)"
            self.pageIndicator.text = "Page: \(Client.pageNumber)"
            self.viewModel.cellViewModels.removeAll()
            self.viewModel.showLoading = {
                if self.viewModel.isLoading {
                    self.indicatorView.startAnimating()
                    self.collectionView.alpha = 0.0
                } else {
                    self.indicatorView.stopAnimating()
                    self.collectionView.alpha = 1.0
                }
            }
            self.viewModel.showError = { error in
                print(error)
            }
            self.viewModel.fetchPhotos()
            self.viewModel.reloadData = {
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                
            }
            self.viewModel.fetchingMore = false
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height        
        if offsetY > contentHeight - frameHeight{
            if viewModel.firstState == 1 && !viewModel.fetchingMore {
                self.beginReloadViaScrollView()
                let topOffest:CGPoint = CGPoint(x: 0,y: -self.collectionView.contentInset.top)
                scrollView.setContentOffset(topOffest, animated: false)
                
            }
            
            viewModel.firstState = 1
            
            
        } else if offsetY < -30  && Client.pageNumber > 1 {
            if viewModel.firstState == 1 && !viewModel.fetchingMore {
                self.beginReloadTop()
                let topOffest:CGPoint = CGPoint(x: 0,y: -self.collectionView.contentInset.top)
                scrollView.setContentOffset(topOffest, animated: false)
                
            }
            
        }
        
        
        
        
    }
    
}


