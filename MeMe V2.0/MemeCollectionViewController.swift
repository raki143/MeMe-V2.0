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
    private var selectedMemeImages = Set<UIImage>()
    private var selectedMemes = Set<NSIndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsMultipleSelection = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultState()

    }


    func setDefaultState(){
        
        // add edit and add UIBarButtonItem
        editOrDoneButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        addORDeleteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapaddOrDelete))
        navigationItem.leftBarButtonItem = editOrDoneButton
        navigationItem.rightBarButtonItem = addORDeleteButton
        
        // deselect every cell in selectedMemes
        for item in selectedMemes{
            collectionView?.deselectItem(at: item as IndexPath, animated: false)
            let cell = collectionView?.cellForItem(at: item as IndexPath) as! MemeCollectionViewCell
            cell.isSelected(false)
        }
        
        // remove all items in selectedMemes
        selectedMemes.removeAll()
        selectedMemeImages.removeAll()
        collectionView?.reloadData()
        
        editingMode = false
        
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
        
            // saving index of selected collection view cell in selectedMemes array.
            let memedImage = cell.collectionCellImageView.image
            selectedMemeImages.insert(memedImage!)
            selectedMemes.insert(indexPath as NSIndexPath)
            cell.isSelected(true)
            addORDeleteButton.isEnabled = true
            
        }else{
            
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = MemeCollection.getMeme(atIndex: indexPath.row)
        navigationController!.pushViewController(detailVC, animated: true)
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if editingMode{
            
            navigationItem.rightBarButtonItem?.isEnabled = selectedMemes.count > 0
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            let memedImage = cell.collectionCellImageView.image
            cell.isSelected(false)
            selectedMemes.remove(indexPath as NSIndexPath)
            selectedMemeImages.remove(memedImage!)
            
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
        
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete selected memes", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Ok", style: .destructive, handler: {
            action in self.deleteMeme()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            action in self.setDefaultState()
        })
        
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    func deleteMeme(){
        
        if selectedMemeImages.count > 0{
            
            for item in selectedMemeImages{
                MemeCollection.remove(Meme: item)
            }
            setDefaultState()
        }
        
    }
    
}
