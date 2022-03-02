//
//  FavoritesViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 16.02.2022.
//

import UIKit
import RxSwift
import Kingfisher

class FavoritesViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    
    private let viewModel : FavoritesViewModel
    private let coordinator : FavoritesCoordinator
    
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder , coordinator : FavoritesCoordinator , viewModel : FavoritesViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        getDatas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDatas()
    }
    
    private func initViews(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        let cellNib = UINib(nibName: "SearchTableViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchCell")
        
    }
    
    private func getDatas(){
        
        viewModel.getDatas().subscribe(onSuccess : { [weak self] state in
            self?.tableView.reloadData()
        }, onFailure:{ error in
            //Handle Error
            print(error)
        }).disposed(by: disposeBag)
        
    }

}

extension FavoritesViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cocktails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell{
            
            guard let cocktail = viewModel.cocktails?[indexPath.row] else{
                return UITableViewCell()
            }
            
            cell.drinkTitle.text = cocktail.drinkName
            cell.drinkDesc.text = cocktail.type
            cell.drinkImage.kf.indicatorType = .activity
            cell.drinkImage.kf.setImage(with: cocktail.imageDownloadUrl)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let drinkId = viewModel.cocktails?[indexPath.row].id else {
            return
        }
        coordinator.gotoDetail(drinkId: drinkId)
    }
    
}

