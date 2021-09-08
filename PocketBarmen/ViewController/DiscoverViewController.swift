//
//  DiscoverViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import UIKit
import Alamofire
import RxSwift

class DiscoverViewController: UIViewController {

    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var indicatorView : UIActivityIndicatorView!
    
    private var viewModel : DiscoverViewModel!
    private var disposeBag : DisposeBag!
    
    private var categories : CategoryResponse!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.hidesWhenStopped = true
        
        setupCategoryCollectionView()
        
        disposeBag = DisposeBag()
        
        viewModel = DiscoverViewModel()
        observeValues()
        viewModel.getCategories()
        
    }
    
    private func observeValues(){
        //Category data binding
        viewModel.categories.subscribe(onNext:{ [weak self] categories in
            self?.updateCollection(categories: categories)
        },onError: { [weak self] error in
            self?.showAlertDialog()
        }).disposed(by: disposeBag)
            
        //Loading State binding
        viewModel.loadingState.subscribe(onNext:{ [weak self] state in
            if state{
                self?.indicatorView.startAnimating()
                return
            }
            self?.indicatorView.stopAnimating()
        }).disposed(by: disposeBag)
        
    }
    
    private func updateCollection(categories : CategoryResponse){
        self.categories = categories
        collectionView.reloadData()
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
    
    private func showAlertDialog(){
        let alertController = UIAlertController(title: "Oops", message: "A error has occurred.Data could not be retrieved.Restart App", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DiscoverViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories != nil) ? categories.drinks.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CategoryCollectionViewCell{
            
            cell.categoryLbl.text = categories.drinks[indexPath.row].name
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
}
