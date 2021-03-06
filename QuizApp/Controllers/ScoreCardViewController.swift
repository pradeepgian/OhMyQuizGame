//
//  ScoreCardViewController.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 29/05/21.
//

import UIKit

class ScoreCardViewController: UIViewController {
    
    private let scoreLabel = UILabel(font: .boldSystemFont(ofSize: 26), textColor: .white, numberOfLines: 0, alignment: .center)
    
    var score: Float = 0
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        scoreLabel.text = String(format: "Your score is %.2f percent", score)
        view.addSubview(scoreLabel)
        scoreLabel.centerInSuperview()
    }
        
}
