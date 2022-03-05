//
//  AVAssetExtension.swift
//  JimmyGolf
//
//  Created by Devabha Manek on 6/19/19.
//  Copyright © 2019 Devabha Manek. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

import SystemConfiguration

extension AVAsset{
    var videoThumbnail:UIImage?{
        
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            
            print("Video Thumbnail genertated successfuly")
            
            return thumbNail
            
        } catch {
            
            print("error getting thumbnail video",error.localizedDescription)
            return nil
            
            
        }
        
    }
}
