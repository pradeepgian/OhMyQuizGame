//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 25/05/21.
//

import UIKit

class QuizViewController: UIViewController {
    
    var questions = [QuestionItem]()
    
    override func viewDidLoad() {
        fetchQuestions()
    }
    
    fileprivate func fetchQuestions() {
        QuizAPI.shared.fetchQuestions { (questionList, error) in
            questions = questionList?.questions ?? []
            print("Question Label = \(questions[0].data.stimulus)")
        }
    }
    
}
