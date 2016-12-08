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

    
    private var editOrDoneButton : UIBarButtonItem!
    private var addORDeleteButton : UIBarButtonItem!
    private var editingMode = false
    private var selectedMemes = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsMultipleSelection = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultState()
        collectionView?.reloadData()
    }


    func setDefaultState(){
        
        // add edit and add UIBarButtonItem
        editOrDoneButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        addORDeleteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapaddOrDelete))
        navigationItem.leftBarButtonItem = editOrDoneButton
        navigationItem.rightBarButtonItem = addORDeleteButton
        
        // If there are no memes, present EditMemeViewController
        if MemeCollection.count() > 0{
            editOrDoneButton.isEnabled = true
        }else{
            presentEditMemeController()
        }
        
        
    }
    
    
    // MARK: UICollectionViewDataSource methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        
        if editingMode{
            
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            selectedMemes.append(indexPath)
            cell.isSelected(true)
            addORDeleteButton.isEnabled = true
            
        }else{
            
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = MemeCollection.getMeme(atIndex: indexPath.row)
        navigationController!.pushViewController(detailVC, animated: true)
            
        }
        
    }
    
    // MARK: edit, add and delete methods
    
    func didTapEdit(){
        
        editingMode = !editingMode
        
        if editingMode{
            
           editOrDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapEdit))
            navigationItem.leftBarButtonItem = editOrDoneButton
            
            addORDeleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showDeleteAlert))
            navigationItem.rightBarButtonItem = addORDeleteButton
            addORDeleteButton.isEnabled = false
            
        }else{
            setDefaultState()
        }
        
    }
    
    func didTapaddOrDelete(){
        
        if editingMode{
            
            
        }else{
            presentEditMemeController()
        }
    }
    
    func presentEditMemeController(){
        
        let memeCreator = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! EditMemeViewController
        present(memeCreator, animated: false, completion: nil)
        
    }
    
    func showDeleteAlert(){
        
    }
    
    
}
