//
//  UIViewControllExtention.swift
//  DrDCannabis
//
//  Created by Devubha Manek on 29/05/18.
//  Copyright © 2018 Devubha Manek. All rights reserved.
//

import UIKit

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
extension UIViewController {
    
    // popViewController
    @IBAction func popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //TODO:- Dismiss controller
    @IBAction func dismisController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //TODO: - Alert Controller Mehtod
    func alertController(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Show alert method
    func showAlertAction(title : String? = nil,
                         message : String? = nil,
                         cancelTitle : String? = nil,
                         cancelBtnType : UIAlertAction.Style? = .cancel,
                         cancelCompletion : (()->())? = nil,
                         okTitle : String? = nil,
                         okCompletion : (()->())? = nil,
                         okBtnType : UIAlertAction.Style? = .default) {
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let strCancelTitle = cancelTitle, !strCancelTitle.isEmpty {
            let alertCancelAction = UIAlertAction(title: strCancelTitle, style: cancelBtnType!) { (UIAlertAction) in
                if cancelCompletion != nil { cancelCompletion!() }
            }
            actionSheet.addAction(alertCancelAction)
        }
        
        if let strOkTitle = okTitle, !strOkTitle.isEmpty {
            let alertokAction = UIAlertAction(title: strOkTitle, style: okBtnType!) { (UIAlertAction) in
                if okCompletion != nil { okCompletion!() }
            }
            actionSheet.addAction(alertokAction)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}


//MARK: - UIApplication  Extension
extension UIApplication {
    
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = viewController as? UINavigationController {
            
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            
            if let selected = tab.selectedViewController {
                
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            
            return topViewController(viewController: presented)
        }
        return viewController
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
