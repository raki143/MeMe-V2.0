//
//  MemeCollectionViewCell.swift
//  MeMe V2.0
//
//  Created by Rakesh on 12/8/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionCellImageView: UIImageView!
    @IBOutlet weak var selectedCellImage: UIImageView!
    
    func isSelected(_ selected:Bool){
        selectedCellImage.isHidden = !selected
    }
    
}
