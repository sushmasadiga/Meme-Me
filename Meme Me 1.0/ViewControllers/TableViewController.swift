//
//  TableViewController.swift
//  Meme Me 1.0
//
//  Created by Sushma Adiga on 19/05/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var memeTableView: UITableViewController!
    
    
    var memes: [Meme]!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
        tableView.delegate = self
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate.memes.count == 0 ? shouldShowAndSetView(true) : shouldShowAndSetView(false)
        return delegate.memes.count
    }
    
    func shouldShowAndSetView(_ shouldShow: Bool) {
        
        if shouldShow {
            
            let screenLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            
            screenLabel.textAlignment = .center
            screenLabel.numberOfLines = 2
            screenLabel.text = "No meme on the memory! Store some"
            
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = screenLabel
            tableView.separatorStyle = .none
            
        } else {
            
            tableView.backgroundView = nil
           navigationItem.leftBarButtonItem = editButtonItem
            
        }
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate.memes.remove(at: indexPath.row)
            
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

            detailController.meme = memes[(indexPath as NSIndexPath).row]
            navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}


