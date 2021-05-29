//
//  QuizHeaderCell.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

class QuizHeaderCell: UICollectionReusableView {
    
    static let headerIdentifier = "QuizHeaderCell_Identifier"
    
    var question: Question! {
        didSet {
            questionLabel.text = question.stimulus
            timerView.timeLeft = question.metadata.duration
        }
    }
    
    private let headerLabel = UILabel(text: "Oh My Quiz!",
                                      font: .boldSystemFont(ofSize: 22),
                                      textColor: .white)
    
    private let questionLabel = UILabel(font: .boldSystemFont(ofSize: 24),
                                      textColor: .white,
                                      numberOfLines: 0,
                                      alignment: .center)
    
    let timerView = CountdownTimerView(radius: 50)
    
    private lazy var stackView = VerticalStackView(arrangedSubviews: [headerLabel, questionLabel, timerView],
                                                   spacing: 20,
                                                   alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
