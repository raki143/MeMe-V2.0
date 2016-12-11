//
//  MemeModel.swift
//  MemeMe-V1.0
//
//  Created by Rakesh Kumar on 27/11/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

struct MemeModel{
    let topText: String!
    let bottomText: String!
    let originalImage: UIImage!
    let memedImage: UIImage!
}

extension MemeModel:Equatable{
    
    static func ==(lhs: MemeModel , rhs: MemeModel) -> Bool {
        return lhs.memedImage == rhs.memedImage
    }
}
// convenience methods and variables for accessing and altering the collection of memes
struct MemeCollection{
    
    private static var allMemes:[MemeModel]{
        return getMemeStorage().memes
    }
    
    static func count() -> Int{
        return allMemes.count
    }
    
    private static func getMemeStorage() -> AppDelegate{
        let object = UIApplication.shared.delegate
        return object as! AppDelegate
    }
    
    static func add(Meme meme:MemeModel){
        getMemeStorage().memes.append(meme)
    }
    
    static func getMeme(atIndex index:Int) -> MemeModel{
        return allMemes[index]
    }
    
    
    static func remove(Meme receivedMeme:UIImage){
        
        for index in 0..<count(){
            
            if allMemes[index].memedImage == receivedMeme{
                removeMeme(atIndex: index)
                return
            }
        }
    }
    
   static func removeMeme(atIndex index:Int){
        getMemeStorage().memes.remove(at: index)
    }
}
