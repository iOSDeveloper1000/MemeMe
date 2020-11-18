//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Arno Seidel on 17.11.20.
//

import Foundation
import UIKit


class MemeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var meme: Meme!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Life cycle methods
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        self.imageView?.image = self.meme?.memed
    }
    
}
