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
    var indexInArray: Int!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var details: UILabel!
    
    
    // MARK: Life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView()
    }
    
    
    // MARK: Actions
    
    @IBAction func editMeme(_ sender: Any) {
        // Set up a new MemeEditorViewController where the existing meme can be edited
        let memeEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.isEdit = true
        memeEditorVC.oldMeme = self.meme
        
        memeEditorVC.completionHandle = { (updated) in
            if updated {
                // Fetch new meme from app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                self.meme = appDelegate.memes[appDelegate.memes.count - 1]
                
                // Remove old meme from memes array after edit
                appDelegate.memes.remove(at: self.indexInArray!)
                self.indexInArray = appDelegate.memes.count - 1
                
                // Update Detail view controller
                self.updateView()
            }
        }

        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    
    // MARK: Helper methods
    
    // Updates image and label
    func updateView() {
        if let meme = self.meme {
            self.imageView.image = meme.memed
            self.details.text = meme.topText + " ... " + meme.bottomText
        }
    }
    
}
