//
//  ThirdViewController.swift
//  The Night Porter
//
//  Created by Islam Elsayed on 5/10/19.
//  Copyright © 2019 Islam Elsayed. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    var list = ["مطعم ساشي","Gad-جاد","Pane Vino- بانيه فينو","Zaitouni-زيتوني","Majesty","Peking","Tespas"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "البحث عن مطعم"
    }
    
    // these functions for picker view
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // number of rows
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
    }
    
    // rows
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    
    // after selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textBox.text = self.list[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you don't want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
    }
    // end of picker view block

    

}
