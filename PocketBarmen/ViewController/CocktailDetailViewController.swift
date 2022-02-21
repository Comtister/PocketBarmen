//
//  CocktailDetailViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 10.11.2021.
//

import UIKit
import RxSwift
import SwiftUI
import Kingfisher

class CocktailDetailViewController: UIViewController {

    weak var coordinator : CocktailDetailCoordinator?
    private var viewModel : CocktailDetailViewModel
    private let disposeBag : DisposeBag = DisposeBag()
    
    @IBOutlet var drinkTitleLbl : UILabel!
    @IBOutlet var drinkImageView : UIImageView! = {
        let drinkImageView = UIImageView()
        drinkImageView.layer.borderWidth = 2
        drinkImageView.layer.borderColor = UIColor(named: "MainBrass")?.cgColor
        drinkImageView.layer.cornerRadius = 10
        drinkImageView.backgroundColor = .white
        drinkImageView.makeSTShadow()
        drinkImageView.layer.masksToBounds = true
        return drinkImageView
    }()
    @IBOutlet var sheetLbl : UILabel!
    @IBOutlet var scroolView : UIScrollView!
    @IBOutlet var indicator : UIActivityIndicatorView!
    
    var barButtonItem : UIBarButtonItem!
    
    required init?(coder: NSCoder , coordinator : CocktailDetailCoordinator , viewModel : CocktailDetailViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getDrinkDetail()
        
    }
    
    private func getDrinkDetail(){
        indicator.startAnimating()
        viewModel.getDrinkDetail().subscribe(onSuccess :{ [weak self] response in
            print(response.name)
            self?.indicator.stopAnimating()
            self?.scroolView.isHidden = false
            self?.setView(cocktailDetail: response)
            self?.drinkImageView.kf.indicatorType = .activity
            self?.drinkImageView.kf.setImage(with : URL(string: "\(response.imageUrl)/preview"))
        },onError: { error in
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupViews(){
        //MARK: Set DrinkImageView
        drinkImageView.layer.borderWidth = 2
        drinkImageView.layer.borderColor = UIColor(named: "MainBrass")?.cgColor
        drinkImageView.layer.cornerRadius = 10
        drinkImageView.backgroundColor = .white
        drinkImageView.makeSTShadow()
        drinkImageView.layer.masksToBounds = true
        
        //MARK: Set Toolbar Save Button
        barButtonItem = UIBarButtonItem(image: UIImage(named: "starw"), style: .plain, target: self, action: #selector(saveAction))
        barButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = barButtonItem
        
        if viewModel.isSaved(){
            barButtonItem.image = UIImage(named: "starb")
        }
        
    }
    
    @objc func saveAction(){
        
        viewModel.saveOrDeleteDrink().subscribe(onSuccess:{ [weak self] state in
            switch state{
            case .Deleted :
                self?.barButtonItem.image = UIImage(named: "starw")
            case .Saved :
                self?.barButtonItem.image = UIImage(named: "starb")
            }
        },onFailure:{ error in
            print("SSWW \(error)")
        }).disposed(by: disposeBag)
        
    }
    
    private func setView(cocktailDetail : CocktailDetail){
        
        //MARK: Set Drink Title
        drinkTitleLbl.text = cocktailDetail.name
        
        
        //MARK: Set Ingredient Table
        //MARK: Constants
        let width = self.view.frame.width - 20
        let heigth = CGFloat(100)
        var ingredientFrameHeigth : CGFloat = 20
        var satir = 1
        var measureHeigth : CGFloat = 0
        //MARK: Ingredients Locate Variables
        //Burayı sınıf haline getir
        //MARK: IngredientFrame
        let ingredientFrame = UIView()
        ingredientFrame.backgroundColor = .white
        ingredientFrame.layer.borderWidth = 2
        ingredientFrame.layer.borderColor = UIColor(named: "MainBrass")?.cgColor
        ingredientFrame.makeSTShadow()
        ingredientFrame.layer.cornerRadius = 10
        //ingredientFrame.layer.masksToBounds = true
        ingredientFrame.isUserInteractionEnabled = false
        ingredientFrame.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: ingredientFrame Constraints
        self.view.addSubview(ingredientFrame)
        ingredientFrame.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        ingredientFrame.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        ingredientFrame.topAnchor.constraint(equalTo: sheetLbl.bottomAnchor, constant: 20).isActive = true
        let frameHeigthConstant = ingredientFrame.heightAnchor.constraint(equalToConstant: heigth)
        
        //MARK: Add Two HorizontalStack
        let alcholFrameView = UIView()
        alcholFrameView.translatesAutoresizingMaskIntoConstraints = false
        ingredientFrame.addSubview(alcholFrameView)
        alcholFrameView.topAnchor.constraint(equalTo: ingredientFrame.topAnchor, constant: 5).isActive = true
        alcholFrameView.leadingAnchor.constraint(equalTo: ingredientFrame.leadingAnchor, constant: 10).isActive = true
        alcholFrameView.widthAnchor.constraint(equalToConstant: width).isActive = true
        alcholFrameView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //MARK: Add FrameTitles
        let alcholLbl = UILabel()
        alcholLbl.text = "Type"
        alcholLbl.translatesAutoresizingMaskIntoConstraints = false
        alcholFrameView.addSubview(alcholLbl)
        alcholLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
        alcholLbl.leadingAnchor.constraint(equalTo: alcholFrameView.leadingAnchor).isActive = true
        
        //MARK: Add AlcholLbl
        let alcholStateLbl = IngredientLabel()
        alcholStateLbl.text = cocktailDetail.category
        alcholStateLbl.translatesAutoresizingMaskIntoConstraints = false
        alcholFrameView.addSubview(alcholStateLbl)
        alcholStateLbl.widthAnchor.constraint(equalToConstant: CGFloat(cocktailDetail.category.count * (50 / 4))).isActive = true
        alcholStateLbl.leadingAnchor.constraint(equalTo: alcholLbl.trailingAnchor, constant: 5).isActive = true
        
        //MARK: Seperator setup
        let seperator = UIView()
        seperator.backgroundColor = .gray
        seperator.layer.cornerRadius = 5
        seperator.translatesAutoresizingMaskIntoConstraints = false
        ingredientFrame.addSubview(seperator)
        seperator.topAnchor.constraint(equalTo: alcholFrameView.bottomAnchor, constant: 5).isActive = true
        seperator.leadingAnchor.constraint(equalTo: ingredientFrame.leadingAnchor, constant: 5).isActive = true
        seperator.widthAnchor.constraint(equalToConstant: width - 10).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //MARK: IngredientFrame setup
        let ingredientFrameView = UIView()
        ingredientFrame.addSubview(ingredientFrameView)
        ingredientFrameView.translatesAutoresizingMaskIntoConstraints = false
        ingredientFrameView.topAnchor.constraint(equalTo: seperator.bottomAnchor , constant: 5).isActive = true
        ingredientFrameView.leadingAnchor.constraint(equalTo: ingredientFrame.leadingAnchor , constant: 10).isActive = true
        ingredientFrameView.widthAnchor.constraint(equalToConstant: width).isActive = true
        let ingredientFrameHeigthAnchor = ingredientFrameView.heightAnchor.constraint(equalToConstant: ingredientFrameHeigth)
        ingredientFrameHeigthAnchor.isActive = true
        
        //MARK: IngredientTitle setup
        let ingredientTitle = UILabel()
        ingredientTitle.text = "Ingredients"
        ingredientTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientFrameView.addSubview(ingredientTitle)
        ingredientTitle.leadingAnchor.constraint(equalTo: ingredientFrameView.leadingAnchor).isActive = true
        ingredientTitle.centerYAnchor.constraint(equalTo: ingredientFrameView.centerYAnchor).isActive = true
        ingredientTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let ingredientFrameWidth = width - 100
        var lastItem : UIView = ingredientTitle
        var totalWidth : CGFloat = 0
        var topAnchorConstant : CGFloat = 0
        
        for item in cocktailDetail.ingredients{
            let ingredientLbl = IngredientLabel()
            ingredientLbl.text = item
            ingredientLbl.translatesAutoresizingMaskIntoConstraints = false
            ingredientFrameView.addSubview(ingredientLbl)
            let itemWidth : CGFloat = CGFloat(item.count * (50 / 4))
            totalWidth += itemWidth + 10
            
            if totalWidth >= ingredientFrameWidth{
                totalWidth = itemWidth + 10
                lastItem = ingredientTitle
                topAnchorConstant += 25
                ingredientFrameHeigth += 25
                ingredientFrameHeigthAnchor.constant = ingredientFrameHeigth
                ingredientLbl.leadingAnchor.constraint(equalTo: lastItem.trailingAnchor, constant: 5).isActive = true
                ingredientLbl.topAnchor.constraint(equalTo: ingredientFrameView.topAnchor, constant: topAnchorConstant).isActive = true
                ingredientLbl.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                lastItem = ingredientLbl
                satir += 1
            }else{
                ingredientLbl.leadingAnchor.constraint(equalTo: lastItem.trailingAnchor, constant: 5).isActive = true
                ingredientLbl.topAnchor.constraint(equalTo: ingredientFrameView.topAnchor, constant: topAnchorConstant).isActive = true
                ingredientLbl.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                lastItem = ingredientLbl
            }
           
        }
        frameHeigthConstant.isActive = true
        frameHeigthConstant.constant = CGFloat(satir * 25) + 37
        
        //MARK: Set Ingredient Label
        let ingredientLbl = UILabel()
        ingredientLbl.text = "Ingredients"
        ingredientLbl.font = UIFont.systemFont(ofSize: 20)
        ingredientLbl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientLbl)
        ingredientLbl.topAnchor.constraint(equalTo: ingredientFrame.bottomAnchor, constant: 10).isActive = true
        ingredientLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //MARK: Set Ingredient Measure List
        let measuresStackView = UIStackView()
        measuresStackView.backgroundColor = .white
        measuresStackView.isUserInteractionEnabled = false
        measuresStackView.axis = .vertical
        measuresStackView.distribution = .fillEqually
        measuresStackView.translatesAutoresizingMaskIntoConstraints = false
        measuresStackView.spacing = 5
        measuresStackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        measuresStackView.isLayoutMarginsRelativeArrangement = true
        measuresStackView.makeSTShadow()
        measuresStackView.layer.borderWidth = 2
        measuresStackView.layer.cornerRadius = 10
        measuresStackView.layer.borderColor = UIColor(named: "MainBrass")?.cgColor
        self.view.addSubview(measuresStackView)
        measuresStackView.topAnchor.constraint(equalTo: ingredientLbl.bottomAnchor, constant: 10).isActive = true
        measuresStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        measuresStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        let measureHeigthConstraint = measuresStackView.heightAnchor.constraint(equalToConstant: measureHeigth)
        
        //MARK: Add MeauserLabels into StackView
        
        for index in 0..<cocktailDetail.ingredients.count{
            //Measure sayısını kontrol et index out of bound hatası doğuruyor
            if index >= cocktailDetail.measures.count{
                continue
            }
            let str = "\(cocktailDetail.measures[index]) \(cocktailDetail.ingredients[index])"
            let measure = MeasureView()
            measure.label.text = str
            measureHeigth += 30
            measuresStackView.addArrangedSubview(measure)
        }
        
        measureHeigthConstraint.constant = measureHeigth
        measureHeigthConstraint.isActive = true
        
        //MARK: Add Preparation Text
        let preparationTitle = UILabel()
        preparationTitle.text = "Preparation"
        preparationTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(preparationTitle)
        preparationTitle.topAnchor.constraint(equalTo: measuresStackView.bottomAnchor, constant: 10).isActive = true
        preparationTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let preparationTextview = UILabel()
        preparationTextview.text = cocktailDetail.instructions
        preparationTextview.numberOfLines = 0
        preparationTextview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(preparationTextview)
        preparationTextview.topAnchor.constraint(equalTo: preparationTitle.bottomAnchor, constant: 10).isActive = true
        preparationTextview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        preparationTextview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        view.layoutIfNeeded()
        let layoutHeigth = preparationTextview.frame.maxY - view.frame.minY
        
        self.scroolView.contentSize = CGSize(width: self.view.frame.width, height: layoutHeigth)
        
        
    }
    
    
}
