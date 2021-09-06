//
//  CategoryCollectionViewCell.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 6.09.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var categoryLbl : UILabel!
    @IBOutlet var categoryImg : UIImageView!
    @IBOutlet private var view : UIView!
    private var tapGesture : UITapGestureRecognizer!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        
        self.addGestureRecognizer(tapGesture)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
    }
    
    @objc func clickAction(){
        
        let firstHalf = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.alpha = 0.5
        }
        
        let secondHalf = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.alpha = 1.0
        }
        
        firstHalf.addCompletion { (position) in
            secondHalf.startAnimation()
        }
        
        firstHalf.startAnimation()
        
    }

    
}
