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
            if questionIndex < questions.count {
                options = questions[questionIndex].data.options
                collectionView.reloadData()
            }
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

    let getReadyLabel = UILabel(text: "Get Ready!", font: .boldSystemFont(ofSize: 30), textColor: .white, numberOfLines: 1, alignment: .center)
    let timerLabel = UILabel(text: "3", font: .boldSystemFont(ofSize: 100), textColor: .white, numberOfLines: 1, alignment: .center)
    lazy var stackView = VerticalStackView(arrangedSubviews: [getReadyLabel, timerLabel], spacing: 40, alignment: .center)
    
    private var timer = Timer()
    
    private var seconds = 3
    lazy private var secondsLeft = TimeInterval(seconds)
    lazy private var waitTimeInSeconds = Date().addingTimeInterval(secondsLeft)
    
    var anchoredConstraintsForStackView: AnchoredConstraints?
    var bottomAnchorForCollectionView: NSLayoutConstraint?
    
    fileprivate func setupUI() {
        view.addSubview(stackView)
        anchoredConstraintsForStackView = stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.topAnchor, trailing: view.trailingAnchor)
        stackView.alpha = 0
        bottomAnchorForCollectionView = collectionView.bottomAnchor.constraint(equalTo: self.view.topAnchor)
        
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
    
    var optionViewConstraints: AnchoredConstraints?
    var startingFrame: CGRect?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? OptionViewCell else { return }
        
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // get cell frame starting position
        self.startingFrame = startingFrame
        let optionView = FullScreenOptionView()
        optionView.optionCellView.option = options[indexPath.item]
        optionView.optionCellView.optionImageView.image = OptionImages.allCases[indexPath.item].image
        
        // add optionView as a subview
        self.view.addSubview(optionView)
        
        //set the option view position same as cell view's position
        self.optionViewConstraints = optionView.anchor(top: self.collectionView.topAnchor, leading: self.collectionView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.optionViewConstraints?.top?.constant = self.view.center.y - startingFrame.height/2
            self.optionViewConstraints?.leading?.constant = self.view.center.x - startingFrame.width/2
            self.optionViewConstraints?.width?.constant = startingFrame.width
            self.optionViewConstraints?.height?.constant = startingFrame.height
            self.bottomAnchorForCollectionView?.isActive = true
            self.collectionView.alpha = 0
            self.view.layoutIfNeeded() // starts animation
        }) { (_) in
            optionView.optionCellView.showResult {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                    self.stackView.alpha = 1
                    self.anchoredConstraintsForStackView?.bottom?.constant = self.view.center.y + 50
                    self.view.layoutIfNeeded()
                }) { (_) in
                    self.startGetReadyTimer()
                }
            }
        }
    }
    
    func startGetReadyTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                      target: self,
                                      selector: (#selector(updateTimer)),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc private func updateTimer() {
        if secondsLeft < 0 {
            timerLabel.text = "0"
            timer.invalidate()
            self.questionIndex += 1
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.stackView.alpha = 0
                self.stackView.transform = .identity
                self.collectionView.alpha = 1
                self.collectionView.transform = .identity
                self.view.layoutIfNeeded()
            })
        } else {
            secondsLeft = waitTimeInSeconds.timeIntervalSinceNow
            let seconds = Int(secondsLeft) % 60
            timerLabel.text = "\(seconds)"
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
