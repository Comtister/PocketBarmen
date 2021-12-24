//
//  UIView+Shadow.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 24.12.2021.
//

import Foundation
import UIKit

extension UIView{
    
    func makeSTShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5
    }
    
}
