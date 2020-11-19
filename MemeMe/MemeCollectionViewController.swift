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

    // MARK: Outlets

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!


    // MARK: Properties
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 2.0
        let shortEdgeLen = (self.view.frame.size.width < self.view.frame.size.height) ? self.view.frame.size.width : self.view.frame.size.height // short edge of display -- depending on orientation
        let dimension = (shortEdgeLen - (2 * space)) / 3.0

        if let flowLayout = self.flowLayout {
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
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
        
        memeEditorVC.completionHandle = { (updated) in
            if updated {
                self.collectionView.reloadData()
            }
        }
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewController delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.meme = self.memes[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Instantiate and initialize MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).item]
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
