//
//  Constant.swift
//  Seema_Assignment
//
//  Created by SOTSYS018 on 03/03/22.
//

import Foundation
import UIKit
var appShared = UIApplication.shared.delegate as! AppDelegate

struct WebURL {
    
    static let tokenKey:String = "Authorization"
    
    static let baseURL = ""
    static let imgBaseURL = "https://image.tmdb.org/t/p/w342"
}

//MARK: -Storyboard list
struct Storyboard {
    static let home = UIStoryboard(name: "Home", bundle: nil)
}

//Save image in to local DB
func saveImage(image: UIImage,strName:String) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        try data.write(to: directory.appendingPathComponent(strName)!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}

func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}
