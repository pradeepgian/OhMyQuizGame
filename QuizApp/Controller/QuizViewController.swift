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
    
    private enum OptionImages: CaseIterable {
        // don't change order
        case optionA
        case optionB
        case optionC
        case optionD

        var image: UIImage? {
            switch self {
            case .optionA:
                return #imageLiteral(resourceName: "OptionA").withRenderingMode(.alwaysOriginal)
            case .optionB:
                return #imageLiteral(resourceName: "OptionB").withRenderingMode(.alwaysOriginal)
            case .optionC:
                return #imageLiteral(resourceName: "OptionC").withRenderingMode(.alwaysOriginal)
            case .optionD:
                return #imageLiteral(resourceName: "OptionD").withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    fileprivate func setupUI() {
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
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
        return .init(width: view.frame.width, height: 325)
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
        cell.option = options[indexPath.item]
        cell.optionImageView.image = OptionImages.allCases[indexPath.item].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    var anchoredConstraints: AnchoredConstraints?
    var startingFrame: CGRect?
    var xAnchor: NSLayoutAnchor<AnyObject>?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? OptionViewCell else { return }
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // get cell frame starting position
        self.startingFrame = startingFrame
        let optionView = ExpandedOptionView()
        optionView.optionCellView.option = options[indexPath.item]
        optionView.optionCellView.optionImageView.image = OptionImages.allCases[indexPath.item].image
        
        // add optionView as a subview
        self.view.addSubview(optionView)
        
        //set the option view position same as cell view's position
        self.anchoredConstraints = optionView.anchor(top: self.collectionView.topAnchor, leading: self.collectionView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded()
        
        //begin animation
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            self.anchoredConstraints?.top?.constant = self.view.center.y - startingFrame.height/2
            self.anchoredConstraints?.leading?.constant = self.view.center.x - startingFrame.width/2
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            self.view.layoutIfNeeded() // starts animation
        }) { (_) in
            
        }
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExpandedOptionView: UIView {
    var optionCellView = OptionViewCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(optionCellView)
        optionCellView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
