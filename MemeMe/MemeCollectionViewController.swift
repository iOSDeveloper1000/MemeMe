//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Arno Seidel on 16.11.20.
//

import Foundation
import UIKit


// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    
    // MARK: Actions
    
    @IBAction func addMeme(_ sender: Any) {
        // Get the Storyboard and MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.completionHandle = {
            self.collectionView.reloadData()
        }
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewController delegate methods
    
    // @todo
}
