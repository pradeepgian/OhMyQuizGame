//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 25/05/21.
//

import UIKit

class QuizViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var questions = [QuestionItem]()
    
    override func viewDidLoad() {
        fetchQuestions()
        setupUI()
    }
    
    fileprivate func fetchQuestions() {
        QuizAPI.shared.fetchQuestions { (questionList, error) in
            questions = questionList?.questions ?? []
            print("Question Label = \(questions[0].data.stimulus)")
        }
    }
    
    fileprivate var questionIndex = 0 {
        didSet {
            
        }
    }
    
    lazy private var options = questions[questionIndex].data.options
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .black
        collectionView.register(QuizHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QuizHeaderCell.headerIdentifier)
        collectionView.register(OptionViewCell.self, forCellWithReuseIdentifier: OptionViewCell.identifier)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuizHeaderCell.headerIdentifier, for: indexPath) as! QuizHeaderCell
        header.question = questions[questionIndex].data
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // This space of 30 pixels is on the right edge, left edge and between 2 cells
        // Hence, 30 * 3 is subtracted from total width of the view
        let sideLength = (view.frame.width - 90) / 2
        return .init(width: sideLength, height: sideLength)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionViewCell.identifier, for: indexPath) as! OptionViewCell
//        cell.option = self.questions[questionIndex].data.options[indexPath.item]
        cell.option = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
