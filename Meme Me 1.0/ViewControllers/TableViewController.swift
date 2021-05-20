//
//  TableViewController.swift
//  Meme Me 1.0
//
//  Created by Sushma Adiga on 19/05/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var memeTableView: UITableViewController!
    
    
    var memes: [Meme]! {
    
    let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           return appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
        tableView.delegate = self
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeSentTableViewCell", for: indexPath) as! TableViewCell
        let memeForRow = memes[indexPath.row]
        cell.imageView?.image = memeForRow.memedImage
        cell.textLabel?.text = memeForRow.topText + "..." + memeForRow.bottomText
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

            
            detailController.meme = memes[(indexPath as NSIndexPath).row]

           
            navigationController!.pushViewController(detailController, animated: true)
    }
    
}


