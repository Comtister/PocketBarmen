//
//  DiscoverViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet var collectionView : UICollectionView!
    
    private var categories : [String] = ["Test","Test","Test","Test","Test","Test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryCollectionView()
       
    }
    
    private func setupCategoryCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = calculateCellSıze()
        
        collectionView.collectionViewLayout = layout
        
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        
    }
    
    private func calculateCellSıze() -> CGSize{
        
        let collectionViewWidth = view.bounds.width
        let usableWidth = collectionViewWidth - 20
        
        let itemWidth = usableWidth / 2
        let itemHeigth = (itemWidth * 3) / 2
        
        return CGSize(width: itemWidth, height: itemHeigth)
        
    }
    
}

extension DiscoverViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CategoryCollectionViewCell{
            
            cell.categoryLbl.text = "Alchol Coctail"
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
}
