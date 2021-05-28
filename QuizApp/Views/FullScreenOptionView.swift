//
//  FullScreenOptionView.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 28/05/21.
//

import UIKit

class FullScreenOptionView: UIView {
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
