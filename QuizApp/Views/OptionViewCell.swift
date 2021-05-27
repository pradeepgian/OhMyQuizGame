//
//  OptionViewCell.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

class OptionViewCell: UICollectionViewCell {
    
    static let identifier = "OptionCell_Identifier"
    private let optionLabel = UILabel(font: .boldSystemFont(ofSize: 16),
                                        textColor: .black,
                                        numberOfLines: 0,
                                        alignment: .center)
    
    var option: Option! {
        didSet {
            optionLabel.text = option.label
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeCell()
        addSubview(optionLabel)
        optionLabel.fillSuperview()
    }
    
    fileprivate func stylizeCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
