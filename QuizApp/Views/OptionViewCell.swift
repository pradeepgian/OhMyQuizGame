//
//  OptionViewCell.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

class OptionViewCell: UICollectionViewCell {
    
    static let identifier = "OptionCell_Identifier"
    
    let optionLabel = UILabel(font: .boldSystemFont(ofSize: 16),
                                        textColor: .black,
                                        numberOfLines: 0,
                                        alignment: .center)
    let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    var option: Option! {
        didSet {
            optionLabel.text = option.label
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeCell()
        let stackView = VerticalStackView.init(arrangedSubviews: [optionImageView, optionLabel],
                                               spacing: 5,
                                               alignment: .center)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 5, bottom: 5, right: 5))
    }
    
    fileprivate func stylizeCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
