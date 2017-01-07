//
//  fontViewController.swift
//  MeMe V2.0
//
//  Created by Rakesh Kumar on 07/01/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

class fontViewController: UIViewController {
    
    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var sizeSlider: UISlider!
    
    var fontAtrributes = FontAttributes()
    let fontFamily = UIFont.familyNames
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for member in fontFamily{
            pickerData.append(contentsOf: UIFont.fontNames(forFamilyName: member))
        }
        
        fontPicker.dataSource = self
        fontPicker.delegate = self
        setUIElementsForFontAttributes()
    }
    
    
    func setUIElementsForFontAttributes(){
        sizeSlider.value = Float(fontAtrributes.fontSize)
        let index = pickerData.index(of: fontAtrributes.fontName)
        if let index = index{
            fontPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func didChangeSliderValue(_ sender: AnyObject) {
        
        let fontSize = CGFloat(sizeSlider.value)
        fontAtrributes.fontSize = fontSize
        updateMemeFont()
    }
    
    func updateMemeFont(){
        
        let parentViewController = presentingViewController as! EditMemeViewController
        parentViewController.fontAttributes.fontSize = fontAtrributes.fontSize
        parentViewController.fontAttributes.fontName = fontAtrributes.fontName
        parentViewController.textFieldsConfiguration(textFields: [parentViewController.topTextField,parentViewController.bottomTextField])
    }
    
    
}

extension fontViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        fontAtrributes.fontName = pickerData[row]
        updateMemeFont()
    }
}
