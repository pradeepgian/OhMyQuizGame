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
            isCorrectImageView.image = option.isCorrectBool ? #imageLiteral(resourceName: "Correct") : #imageLiteral(resourceName: "Incorrect")
        }
    }
    
    let isCorrectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var stackView = VerticalStackView.init(arrangedSubviews: [optionImageView, optionLabel],
                                                spacing: 5,
                                                alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeCell()
        
        addSubview(isCorrectImageView)
        isCorrectImageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))

        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 5, bottom: 5, right: 5))
    }
    
    fileprivate func stylizeCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
    }
    
    func showResult(){
        isCorrectImageView.alpha = 1
        UIView.transition(from: stackView, to: isCorrectImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
