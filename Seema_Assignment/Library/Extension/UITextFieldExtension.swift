//
//  UITextFieldExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/17/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

let datePicker = UIDatePicker()
private var __maxLengths = [UITextField: Int]()

//MARK: - UITextfield Extension
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
           // Create a UIDatePicker object and assign to inputView
           let screenWidth = UIScreen.main.bounds.width
           let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        
        
           datePicker.datePickerMode = .date //2
           self.inputView = datePicker //3
           
          datePicker.maximumDate = Date()
           // Create a toolbar and assign it to inputAccessoryView
           let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
           let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
           let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
           let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
           toolBar.setItems([cancel, flexible, barButton], animated: false) //8
           self.inputAccessoryView = toolBar //9
       }
       
       @objc func tapCancel() {
           self.resignFirstResponder()
       }
       
    
    //awakeFromNib
    open override func awakeFromNib() {
        if self.placeholder != nil {
            self.placeholder = NSLocalizedString(self.placeholder!, comment: "")
        }
    }
    
    //Set AddLeft View
    @IBInspectable var isAddLeftView:Bool{
        set {
            if newValue {
                let leftView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 7, height: self.frame.height))
                leftView.backgroundColor = UIColor.clear
                
                self.leftView = leftView;
                
                self.leftViewMode = UITextField.ViewMode.always
                self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            }
        }
        get {
            return (self.leftView != nil)
        }
    }
    
    //Set Asterisk PlaceHolder
    @IBInspectable var isMandatory:Bool{
        set {
            
            if newValue == true {
                if self.placeholder != nil {
                    
                    let passwordAttriburedString = NSMutableAttributedString(string: NSLocalizedString(self.placeholder!, comment: ""))
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.orange ]
                    let asterix = NSAttributedString(string: " *", attributes: myAttribute)
                    passwordAttriburedString.append(asterix)
                    self.attributedPlaceholder = passwordAttriburedString
                }
            } else {
                if self.placeholder != nil {
                    if  self.placeholder?.last == "*" {
                        self.placeholder = String((self.placeholder?.dropLast())!)
                    }
                }
            }
        }
        get {
            if self.placeholder != nil {
                return self.placeholder?.last == "*" ? true : false
            } else {
                return false
            }
        }
    }
    
    //maxLength
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    //Set placeholder font
    func setPlaceholderFont(font: UIFont) {
        
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.font = font
    }
    //Set placeholder color
    func setPlaceholderColor(color: UIColor) {
        
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.textColor = color
    }
    //Set clear icon
    func setClearIcon(iconName:String) {
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named:"imgRejectRequest"), for: .normal)
            clearButton.setImage(UIImage(named:"imgRejectRequest"), for: .highlighted)
            
        }
    }
    
    func isBlank() -> Bool {
        return self.text?.removeWhiteSpace() == "" ? true : false
    }
    
    func isValid(Regex:String) -> Bool {
        let txt = NSPredicate(format:"SELF MATCHES %@", Regex)
        return !txt.evaluate(with: self.text?.removeWhiteSpace())
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    func isValidPass() -> Bool {
        if self.text!.count <= 7 {
            return false
        }
        return true
        
    }
   
    func isValidPhoneNumber(phoneStr:String) -> Bool {
        let telefonRegex = "^[0-9]{10}$"
        
        let phonePred = NSPredicate(format:"SELF MATCHES %@", telefonRegex)
        return phonePred.evaluate(with: phoneStr)
    }
    
    
}

