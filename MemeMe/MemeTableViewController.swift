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
    
    // MARK: Outlets
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
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
        
        let tableView = self.view as! UITableView
        tableView.reloadData()
    }
    
    
    // MARK: Actions
    
    @IBAction func addMeme(_ sender: Any) {
        // Get the Storyboard and MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.completionHandle = {
            let tableView = self.view as! UITableView
            tableView.reloadData()
        }
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "MemeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memed
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the Storyboard and MemeDetailViewControlled
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.memeImage = memes[(indexPath as NSIndexPath).row].memed
        
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
