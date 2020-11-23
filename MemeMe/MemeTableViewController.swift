//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Arno Seidel on 16.11.20.
//

import Foundation
import UIKit


// MARK: - MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var memes: [Meme]! {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
    }
    
    
    // MARK: Life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tableView = self.view as! UITableView
        tableView.reloadData()
    }
    
    
    // MARK: Actions
    
    @IBAction func addMeme(_ sender: Any) {
        // Get the Storyboard and MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.completionHandle = { (updated) in
            if updated {
                let tableView = self.view as! UITableView
                tableView.reloadData()
            }
        }
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memed
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate and initialize MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let row = (indexPath as NSIndexPath).row
        detailController.meme = memes[row]
        detailController.indexInArray = row
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteEntryFromMemesArray(index: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: Helper methods
    
    func deleteEntryFromMemesArray(index indexPath: IndexPath) {

        let index = (indexPath as NSIndexPath).row
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if index < appDelegate.memes.count {
            appDelegate.memes.remove(at: index)
        } else {
            print("Trying to delete non-existing entry")
        }
    }
}
