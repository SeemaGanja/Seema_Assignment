//
//  UITextViewExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 9/13/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

extension UITextView {
    
    func setPlaceholder(placeholder:String, color:UIColor, isMandatory:Bool) {
        
        let placeholderLabel = UILabel()
        let placeHolderAttribute = [ NSAttributedString.Key.foregroundColor:color ]
        let passwordAttriburedString = NSMutableAttributedString(string: placeholder, attributes: placeHolderAttribute)
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.orange ]
        if isMandatory {
            let asterix = NSAttributedString(string: " *", attributes: myAttribute)
            passwordAttriburedString.append(asterix)
        }
        placeholderLabel.attributedText = passwordAttriburedString
        
        placeholderLabel.font = UIFont.init(name: (self.font?.fontName)!, size: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

