//
//  DiscoverViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import UIKit
import RxSwift

class DiscoverViewController: UIViewController {

    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var indicatorView : UIActivityIndicatorView!
    
    //private var viewModel : DiscoverViewModel = DiscoverViewModel()
    private var viewModel : DiscoverViewModel
    private var coordinator : CatalogCoordinator
    private var disposeBag : DisposeBag = DisposeBag()
    
    private var categories : CategoryResponse?
    
    private var images : [UIImage] = {
        var images : [UIImage] = []
        images.append(UIImage(named: "Ordinary")!)
        images.append(UIImage(named: "Cocktail")!)
        images.append(UIImage(named: "Shake")!)
        images.append(UIImage(named: "Other")!)
        images.append(UIImage(named: "Cocoa")!)
        images.append(UIImage(named: "Shot")!)
        images.append(UIImage(named: "Tea")!)
        images.append(UIImage(named: "Homemade")!)
        images.append(UIImage(named: "Party")!)
        images.append(UIImage(named: "Beer")!)
        images.append(UIImage(named: "Soft")!)
        return images
    }()
   
    required init?(coder: NSCoder , viewModel : DiscoverViewModel , coordinator : CatalogCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        indicatorView.hidesWhenStopped = true
        
        setupCategoryCollectionView()
        
        observeValues()
        getDatas()
    }
    
    private func observeValues(){
        
        viewModel.loadingState.subscribe(onNext:{ [weak self] state in
            state == true ? self?.indicatorView.startAnimating() : self?.indicatorView.stopAnimating()
        }).disposed(by: disposeBag)

        viewModel.networkState.subscribe(onNext:{ state in
            //Test Real Device
            print("Change status \(state)")
        }).disposed(by: disposeBag)
        
    }
    
    private func getDatas(){
        viewModel.getCategories().subscribe { [weak self] (response) in
            self?.updateCollection(categories: response)
        } onFailure: { [weak self] (error) in
            guard let error = error as? NetworkServiceError else {return}
            
            switch error{
            case .NetworkError :
                self?.showAlertDialog(message: Constants.NetworkErrString)
            case .ServerError :
                self?.showAlertDialog(message: Constants.ServerErrString)
            case .DataNotValid , .DataParsingError :
                break
            }
            
        }.disposed(by: disposeBag)
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
    
    private func showAlertDialog(message : String){
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
            self?.getDatas()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DiscoverViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.drinks.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CategoryCollectionViewCell{
            
            if let categories = categories{
                cell.categoryLbl.text = categories.drinks[indexPath.row].name
                cell.categoryImg.image = images[indexPath.row]
                return cell
            }
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
}
