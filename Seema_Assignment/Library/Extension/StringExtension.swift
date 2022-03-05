//
//  StringExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/17/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

//MARK: - String Extension
extension String {
    //Get string length
    var length: Int { return self.count    }  // Swift 2.0
    
    
    
    //Remove white space in string
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //Check string is number or not
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    //Check string is Float or not
    var isFloat : Bool {
        get{
            
            if Float(self) != nil {
                return true
            }else {
                return false
            }
        }
    }
    
    
    //Convert HTML to string
    init?(htmlEncodedString: String) {
        
        guard htmlEncodedString.data(using: .utf8) != nil else {
            return nil
        }
        
        //        let options: [Any: Any] = [
        //            NSAttributedString.DocumentAttributeKey.documentType.rawValue: NSAttributedString.DocumentType.html,
        //            NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue: String.Encoding.utf8.rawValue
        //        ]
        //
        //        guard let attributedString = try? NSAttributedString(data: data, options: options as! [NSAttributedString.DocumentReadingOptionKey : Any], documentAttributes: nil) else {
        //            return nil
        //        }
        
        self.init("attributedString.string")
    }
    //Format Number If Needed
    func formatNumberIfNeeded() -> String {
        
        let charset = CharacterSet(charactersIn: "0123456789.,")
        if self.rangeOfCharacter(from: charset) != nil {
            
            let currentTextWithoutCommas:NSString = (self.replacingOccurrences(of: ",", with: "")) as NSString
            
            if currentTextWithoutCommas.length < 1 {
                return ""
            }
            let numberFormatter: NumberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            let numberFromString: NSNumber = numberFormatter.number(from: currentTextWithoutCommas as String)!
            let formattedNumberString: NSString = numberFormatter.string(from: numberFromString)! as NSString
            
            let convertedString:String = String(formattedNumberString)
            return convertedString
            
        } else {
            return self
        }
    }
    
    //MARK: - convert String To Dictionary
    func convertStrgToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //MARK: - Check Contains Capital Letter
    func isContainsLetterAnsSpace() -> Bool {
        return true
        let capitalLetterRegEx  = ".*[^A-Za-z ].*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = textTest.evaluate(with: self)
        return capitalResult
    }

    func isContainsCapital() -> Bool {
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = textTest.evaluate(with: self)
        return capitalResult
    }
    //MARK: - Check Contains Number Letter
    func isContainsNumber() -> Bool {
        
        let numberRegEx  = ".*[0-9]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = textTest.evaluate(with: self)
        return numberResult
    }
    //MARK: - Check Contains Special Character
    func isContainsSpecialCharacter() -> Bool {
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = textTest.evaluate(with: self)
        return specialResult
    }
    //MARK: - Formate phone number
    func formatPhoneNumber() -> String {
        
        // Remove any character that is not a number
        let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return ""
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return ""
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return ""
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return ""
        }
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    //Number Suffix
    func numberSuffix(from number: Int) -> String {
        
        switch number {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    //Convert Base 64 To Image
    func convertBase64ToImage() -> UIImage {
        
        let imageData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    //Convert Base 64 To Image
    func convertBase64ToData() -> Data {
        
        let imageData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return imageData
    }
    
    //Validation of Regex
    func isValid(Regex:String) -> Bool {
        let txt = NSPredicate(format:"SELF MATCHES %@", Regex)
        return !txt.evaluate(with: self)
    }
    
    
    
    //Get string from skip index
    func toLengthOf(length:Int) -> String {
        if length <= 0 {
            return self
        } else if let to = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
            return self.substring(from: to)
        } else {
            return ""
        }
    }
    
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) == true {
                return ($0 + " " + String($1))
            } else {
                return $0 + String($1)
            }
        }
    }
    
    //safelyLimitedTo
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    //MARK: Localize function
    func localize() -> String{
        return NSLocalizedString(self, comment: "")
    }
}
extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

func createStringNew(value: AnyObject) -> String {
    if let str: String = value as? String { return str }
    else if let str: Int = value as? Int { return String.init(format: "%d", str) }
    else if let str: Double = value as? Double { return String.init(format: "%f", str) }
    else if let str: Float = value as? Float { return String.init(format: "%.2f", str) }
    else if let _: NSNull = value as? NSNull { return String.init(format: "") }
    return ""
}

//MARK: - check string nil
func createString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String {
        
        returnString = str
        
    } else if let str: Int = value as? Int {
        
        returnString = String.init(format: "%d", str)
        
    } else if let _: NSNull = value as? NSNull {
        
        returnString = String.init(format: "")
    }
    return returnString
}
//MARK: - check string nil
func createFloatToString(value: AnyObject) -> String {
    
    var returnString: String = ""
    if let str: String = value as? String {
        
        returnString = str
        
    } else if let str: Float = value as? Float {
        
        returnString = String.init(format: "%.2f", str)
        
    } else if let _: NSNull = value as? NSNull {
        
        returnString = String.init(format: "")
    }
    return returnString
}
func createDoubleToString(value: AnyObject) -> String {
    
    var returnString: String = ""
    if let str: String = value as? String {
        
        returnString = str
        
    } else if let str: Double = value as? Double {
        
        returnString = String.init(format: "%.2f", str)
        
    } else if let _: NSNull = value as? NSNull {
        
        returnString = String.init(format: "")
    }
    return returnString
}


//MARK: - Get perfect number float or integer
func getPerfectNumberFloatOrInt(number:Float) -> String {
    
    let reviews_av = number
    let isInteger = floor(reviews_av) == reviews_av
    var strReviews_av = ""
    if (isInteger) {
        
        strReviews_av = String(Int(reviews_av))
    } else {
        
        strReviews_av = String(format: "%.1f", reviews_av)
    }
    return strReviews_av
}


func getStringFromDictionary(dictionary:NSDictionary, key:String) -> String {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return ""
        }
        return string.removeWhiteSpace()
    }
    return ""
}
//MARK: - Get Bool From Dictionary
func getBoolFromDictionary(dictionary:NSDictionary, key:String) -> Bool {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string.lowercased() == "null" || string == "nil") {
            return false
        }
        if (string.isNumber) {
            
            return Bool(NSNumber(integerLiteral: Int(string)!))
        } else if (string.lowercased() == "false" || string == "0") {
            return false
            
        } else if (string.lowercased() == "true" || string == "1") {
            return true
            
        } else {
            return false
        }
    }
    return false
}
//MARK: - Get Int From Dictionary
func getIntFromDictionary(dictionary:NSDictionary, key:String) -> Int {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return 0
        }
        
        if (string.isNumber) {
            
            return Int(string)!
        } else {
            return 0
        }
        
    }
    return 0
}
//MARK: - Get Double From Dictionary
func getDoubleFromDictionary(dictionary:NSDictionary, key:String) -> Double {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return Double(0.0)
        }
        if (string.isFloat) {
            
            return Double(string)!
        } else {
            return Double(0.0)
        }
    }
    return Double(0.0)
}
//MARK: - Get Float From Dictionary
func getFloatFromDictionary(dictionary:NSDictionary, key:String) -> Float {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return Float(0.0)
        }
        if (string.isFloat) {
            
            return Float(string)!
        } else {
            return Float(0.0)
        }
    }
    return Float(0.0)
}
//MARK: - Get Dictionary From Dictionary
func getDictionaryFromDictionary(dictionary:NSDictionary, key:String) -> NSDictionary {
    
    if let value = dictionary[key] as? NSDictionary {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSDictionary()
        }
        return value
    }
    return NSDictionary()
}
//MARK: - Get Array From Dictionary
func getArrayFromDictionary(dictionary:NSDictionary, key:String) -> NSArray {
    
    if let value = dictionary[key] as? NSArray {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSArray()
        }
        return value
    }
    return NSArray()
}


//MARK:- DateFormate Converter from strings
extension String {
    
    //Convert to dd MMM, YYYY
    func convertToDD_MMM_YYYY() -> String {
        
        if self == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //         dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd MMM, YYYY"
        return dateFormatter.string(from: date!)
    }
    
    //Convert to MMM dd yyyy
    func convertToMMM_dd_yyyy() -> String {
        
        if self == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return dateFormatter.string(from: date!)
    }
    
    // Convert to yyyy-mm-dd
    func convertToYYYY_MM_dd() -> String {
        
        if self == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //         dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date!)
    }
    
    func convertToYYYY_MM_ddFrom_MMM_dd() -> String {
        
        if self == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //         dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date!)
    }
    
    //Convert to "MMM dd, yyyy"
     func convertTo_MMM_dd_yyyy_From_yyyy_MM_dd() -> String {
         
         if self == "" {
             return ""
         }
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.timeZone = TimeZone(identifier: "UTC")
         //         dateFormatter.timeZone = TimeZone.current
         let date = dateFormatter.date(from: self)
         dateFormatter.dateFormat = "MMM dd, yyyy"
         return dateFormatter.string(from: date!)
     }
    


}

extension String {
    
func fromBase64() -> String {
    
    //TODO: Change_PB - Added to remove \n due to
    let strToDycript = self
    
    guard let data = Data(base64Encoded: strToDycript, options: Data.Base64DecodingOptions.init(rawValue: 0)) else {
        return self
    }
    return String(data: data, encoding: .utf8) ?? self
}
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}







