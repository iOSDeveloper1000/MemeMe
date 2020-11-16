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
    
    var memeImage: UIImage!
    var detailString: String!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let memeImage = self.memeImage {
            self.imageView.image = memeImage
        }
    }
    
    
}
