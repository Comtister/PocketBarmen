//
//  IngredientLabel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.11.2021.
//

import UIKit

class IngredientLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)))
    }
    
    private func commonInit(){
        
        self.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.5)
        self.layer.masksToBounds = true
        self.font = UIFont(descriptor: UIFontDescriptor(), size: 17.0)
        self.textAlignment = .center
        
    }

}
