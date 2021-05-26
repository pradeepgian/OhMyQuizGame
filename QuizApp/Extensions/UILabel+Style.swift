//
//  UILabel+Style.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

extension UILabel {
    
    public convenience init(text: String? = nil,
                            font: UIFont? = nil,
                            textColor: UIColor,
                            numberOfLines: Int = 1,
                            alignment: NSTextAlignment = .left,
                            lineHeight: CGFloat? = nil) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        if let font = font {
            self.font = font
        }
    }
    
}
