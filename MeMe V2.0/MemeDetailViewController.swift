//
//  MemeDetailViewController.swift
//  MeMe V2.0
//
//  Created by Rakesh Kumar on 06/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var meme:MemeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let meme = meme{
           imageView.image = meme.memedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
