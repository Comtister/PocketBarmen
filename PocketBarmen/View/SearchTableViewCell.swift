//
//  SearchTableViewCell.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var drinkImage : UIImageView!
    @IBOutlet var drinkTitle : UILabel!
    @IBOutlet var drinkDesc : UILabel!
    @IBOutlet var indicator : UIActivityIndicatorView!
    @IBOutlet private var wrapperView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var backConfig = UIBackgroundConfiguration.listPlainCell()
        backConfig.backgroundColor = .systemBackground
        backgroundConfiguration = backConfig
        
        wrapperView.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            handleClickAnim()
        }
        
    }
    
    func handleClickAnim(){
        
        let firstHalf = UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in
            self?.wrapperView.alpha = 0.5
        }
        
        let secondHalf = UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in self?.wrapperView.alpha = 1.0
        }
        
        firstHalf.addCompletion { (position) in
            secondHalf.startAnimation()
        }
        
        firstHalf.startAnimation()
        
    }
    
}
