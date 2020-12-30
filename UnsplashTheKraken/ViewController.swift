//
//  ViewController.swift
//  UnsplashTheKraken
//
//  Created by Rizqi Imam Gilang Widianto on 29/12/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let images: [UIImage] = [#imageLiteral(resourceName: "image-2"),#imageLiteral(resourceName: "image-4"),#imageLiteral(resourceName: "image-4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? CollectionViewLayout{
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Do any additional setup after loading the view.
    }
//
//    https://api.unsplash.com/search/photos?page=1&query=jakarta&client_id=VXW1shYNLxyVT0_bJ9NW7lg1BiPECg1UYYsRmgTDm9o
}


extension ViewController: CollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = images[indexPath.item]
        let height = image.size.height / 2
        return height
    }
    

}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let image = images[indexPath.item]
        cell.imageView.image = image
        return cell
    }
    
    
}
