//
//  OptionViewCell.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

class OptionViewCell: UICollectionViewCell {
    
    static let identifier = "OptionCell_Identifier"
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .init(scaleX: 0.95, y: 0.95)
                }) { (_) in
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.transform = .identity
                    })
                }
            }
        }
    }
    
    private let optionLabel = UILabel(font: .boldSystemFont(ofSize: 14),
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
            optionLabel.text = String(htmlEncodedString: option.label)
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
    
    private lazy var stackView = VerticalStackView.init(arrangedSubviews: [optionImageView, optionLabel],
                                                spacing: 5,
                                                alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeCell()
        
        contentView.addSubview(isCorrectImageView)
        isCorrectImageView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))

        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 5, bottom: 5, right: 5))
    }
    
    private func stylizeCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        optionLabel.sizeToFit()
    }
    
    func showResult(completion: @escaping () -> ()){
        isCorrectImageView.alpha = 1
        
        UIView.transition(from: stackView, to: isCorrectImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { (_) in
            
            var animationDelay = 1.0
            if self.option.isCorrectBool {
                animationDelay += 2.0
                let confettiEmitter = ConfettiEmitter.get(with: #imageLiteral(resourceName: "confetti"))
                confettiEmitter.position = CGPoint(x: self.frame.size.width/2, y: 0)
                confettiEmitter.emitterSize = .init(width: 100, height: 2)
                self.layer.addSublayer(confettiEmitter)
                confettiEmitter.beginTime = CACurrentMediaTime()
                confettiEmitter.setValue(NSNumber(value: 10000), forKeyPath: "emitterCells.confetti.birthRate")

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    confettiEmitter.setValue(NSNumber(value: 0), forKeyPath: "emitterCells.confetti.birthRate")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    confettiEmitter.removeFromSuperlayer()
                    confettiEmitter.removeAllAnimations()
                }
            }
            
            UIView.animate(withDuration: 0.5, delay: animationDelay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .init(scaleX: 0.01, y: 0.01)
            }) { (_) in
                self.transform = .init(scaleX: 0, y: 0)
                completion()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
