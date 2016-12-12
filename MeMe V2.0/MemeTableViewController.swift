//
//  MemeTableViewController.swift
//  MeMe V2.0
//
//  Created by Rakesh Kumar on 06/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addMemeIfMemeCollectionIsEmpty()
        navigationItem.leftBarButtonItem?.isEnabled = MemeCollection.count() > 0
        tableView!.reloadData()
        
    }
    
    @IBAction func addMeme(_ sender: AnyObject) {
        
        presentEditMemeController()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MemeCollection.count()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        let meme = MemeCollection.getMeme(atIndex: indexPath.row)
        cell.imageView?.image = meme.originalImage
        cell.textLabel?.text = meme.topText
        
        if let detailText = cell.detailTextLabel{
            detailText.text = meme.bottomText
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            MemeCollection.removeMeme(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            addMemeIfMemeCollectionIsEmpty()
            
        default:
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !tableView.isEditing {
            
            let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            detailVC.meme = MemeCollection.getMeme(atIndex: indexPath.row)
            navigationController!.pushViewController(detailVC, animated: true)
        }
    }
    
    func addMemeIfMemeCollectionIsEmpty(){
        
        if MemeCollection.count() == 0{
            
            presentEditMemeController()
            
        }

    }
    
    func presentEditMemeController(){
        
        let memeCreator = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! EditMemeViewController
        present(memeCreator, animated: false, completion: nil)
        
    }

}
