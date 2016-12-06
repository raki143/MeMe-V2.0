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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        // Return false if you do not want the specified item to be editable.
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
