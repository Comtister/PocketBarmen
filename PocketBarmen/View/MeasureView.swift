//
//  MeasureView.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 22.12.2021.
//

import UIKit

class MeasureView: UIView {

    lazy var label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "MainBrass")?.cgColor
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.addSubview(label)
        setConstraints()
    }
    
    private func setConstraints(){
        
        //MARK: Label Constraints
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }

}
