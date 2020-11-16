//
//  Meme.swift
//  MemeMe
//
//  Created by Arno Seidel on 04.11.20.
//

import Foundation
import UIKit


// MARK: Meme Model Object Class

struct Meme {
    
    // MARK: Properties
    
    let topText: String
    let bottomText: String
    let original: UIImage
    let memed: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.original = originalImage
        self.memed = memedImage
    }
    
}
