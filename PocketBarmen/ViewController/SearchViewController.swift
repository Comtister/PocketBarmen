//
//  SearchViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var indicator : UIActivityIndicatorView!
    
    private let viewModel : SearchViewModel = SearchViewModel()
    private let disposeBag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSeacrhBar()
        observeValues()
        getCocktails()
        
    }
    
    private func setupTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 80
       
        let tableCellNib = UINib(nibName: "SearchTableViewCell", bundle: Bundle.main)
        
        tableView.register(tableCellNib, forCellReuseIdentifier: "SearchCell")
    }
    
    private func setupSeacrhBar(){
        self.searchBar.delegate = self
    }
    
    private func getCocktails(){
        
        viewModel.getCocktails()
        
    }
    
    private func observeValues(){
        
        viewModel.loadingState.subscribe(onNext:{ [weak self] state in
            state == true ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
        }).disposed(by: disposeBag)
        
        viewModel.networkState.subscribe(onNext:{ state in
            //Test Real Device
        }).disposed(by: disposeBag)
        
        //Filtre zinciri denenecek
        viewModel.cocktails.subscribe(onNext:{ [weak self] response in
            self?.tableView.reloadData()
        },onError : { error in
            //Handle error
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    private func showAlertDialog(message : String){
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
            self?.getCocktails()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

extension SearchViewController : UITableViewDataSource , UITableViewDelegate , UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoading(indexPath:)) && viewModel.searchState == false{
            viewModel.getCocktails()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentData.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell{
            
            let cocktail = viewModel.currentData.drinks[indexPath.row]
            cell.drinkTitle.text = cocktail.drinkName
            cell.drinkImage.image = cocktail.image
            return cell
        }
        return UITableViewCell()
    }
    
    private func isLoading(indexPath : IndexPath) -> Bool{
        let count = viewModel.currentData.drinks.count
        return indexPath.row >= count - 1
    }
    
}

extension SearchViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCocktail(searchText: searchText)
    }
    
}
