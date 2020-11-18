//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Arno Seidel on 17.11.20.
//

import Foundation
import UIKit


// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var details: UILabel!
    
    
    // MARK: Life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let meme = self.meme {
            self.imageView.image = meme.memed
            self.details.text = meme.topText + " ... " + meme.bottomText
        }
    }
    
    
}
