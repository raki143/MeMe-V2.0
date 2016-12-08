//
//  MemeCollectionViewController.swift
//  MeMe V2.0
//
//  Created by Rakesh Kumar on 06/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {

    
    var editOrDoneButton : UIBarButtonItem!
    var addORDeleteButton : UIBarButtonItem!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editOrDoneButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        addORDeleteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapaddOrDelete))
        navigationItem.leftBarButtonItem = editOrDoneButton
        navigationItem.rightBarButtonItem = addORDeleteButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }


    // MARK: UICollectionViewDataSource methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MemeCollection.count()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        cell.collectionCellImageView.image = MemeCollection.getMeme(atIndex: indexPath.item).memedImage
    
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
    
        return cell
    }

    // MARK: UICollectionViewDelegate methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = MemeCollection.getMeme(atIndex: indexPath.row)
        navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
    func didTapEdit(){
        
        
        
    }
    
    func didTapaddOrDelete(){
        
    }
}
