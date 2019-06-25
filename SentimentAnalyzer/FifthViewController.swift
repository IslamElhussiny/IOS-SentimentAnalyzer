//
//  FifthViewController.swift
//  The Night Porter
//
//  Created by Islam Elsayed on 5/12/19.
//  Copyright © 2019 Islam Elsayed. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // restaurants type lists
    var resType = ["هندي","شرقي","غربي"]
    var indian = ["ساشي","Gad-جاد","Pane Vino- بانيه فينو"]
    var sharki = ["Pane Vino- بانيه فينو","Zaitouni-زيتوني","Majesty"]
    var western = ["Majesty","Peking","Tesppas"]
    var resIDs = [101,102,103,104,105,106,107]
    let resTypePV = UIPickerView()
    let resPV = UIPickerView()
    // global variables to get the data from UI and passed to json
    var restaurantTypeValue : String?
    var restaurantNameValue : String?
    var userReviewValue : String?
    var restaurantID : Int?
    
    @IBOutlet weak var resTypeTB: UITextField!
    @IBOutlet weak var resTB: UITextField!
    @IBOutlet weak var reviewTB: UITextField!
    
    @IBOutlet weak var ConfirmationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "اضافة تعليق"
        resTypePV.delegate = self
        resTypePV.tag = 1
        resTypeTB.inputView = resTypePV
        
        
        resPV.delegate = self
        resPV.tag = 2
        resTB.inputView = resPV
        
        reviewTB.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        reviewTB.delegate = self
        
        
        
        
    }
    
    
    
    
    
    // these functions for picker view
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView.tag == 1 {
            return resType.count
        }
        if pickerView.tag == 2 {
            if resTypeTB.text == "هندي"{
                return indian.count
            }
            else if resTypeTB.text == "شرقي"{
                return sharki.count
            }
            else if resTypeTB.text == "غربي"{
                return western.count
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return resType[row]
        }
        
        if pickerView.tag == 2 {
            if resTypeTB.text == "هندي"{
                return indian[row]
            }
            else if resTypeTB.text == "شرقي"{
                return sharki[row]
            }
            else if resTypeTB.text == "غربي"{
                return western[row]
            }
            
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            resTypeTB.text = resType[row]
            self.view.endEditing(true)
        }
        if pickerView.tag == 2 {
            if resTypeTB.text == "هندي"{
                restaurantTypeValue = resTypeTB.text!
                resTB.text = indian[row]
                restaurantNameValue = resTB.text!
                if restaurantNameValue == "ساشي"{
                    restaurantID = 101
                }
                else if restaurantNameValue == "Gad-جاد"{
                    restaurantID = 102
                }
                else if restaurantNameValue == "Pane Vino- بانيه فينو"{
                    restaurantID = 103
                }
                print(restaurantTypeValue!)
                print(restaurantNameValue!)
                print(restaurantID!)
                self.view.endEditing(true)
            }
            else if resTypeTB.text == "شرقي"{
                restaurantTypeValue = resTypeTB.text!
                resTB.text = sharki[row]
                restaurantNameValue = resTB.text!
                if restaurantNameValue == "Pane Vino- بانيه فينو"{
                    restaurantID = 103
                }
                else if restaurantNameValue == "Zaitouni-زيتوني"{
                    restaurantID = 104
                }
                else if restaurantNameValue == "Majesty"{
                    restaurantID = 105
                }
// to ensure that the values are selected and saved into the global variable
                print(restaurantTypeValue!)
                print(restaurantNameValue!)
                print(restaurantID!)
                self.view.endEditing(true)
            }
            else if resTypeTB.text == "غربي"{
                restaurantTypeValue = resTypeTB.text!
                resTB.text = western[row]
                restaurantNameValue = resTB.text!
                if restaurantNameValue == "Majesty"{
                    restaurantID = 105
                }
                else if restaurantNameValue == "Peking"{
                    restaurantID = 106
                }
                else if restaurantNameValue == "Tesppas"{
                    restaurantID = 107
                }
                print(restaurantTypeValue!)
                print(restaurantNameValue!)
                print(restaurantID!)
                self.view.endEditing(true)
            }
            
        }
    }
    
    // for text field entry
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        userReviewValue = textFieldText
        print(userReviewValue!)
        if count > 120 {
            DispatchQueue.main.async { // Correct
                self.ConfirmationLabel.text = "من فضلك اكتب تعليقا لا ي تجاوز 120 حرفا"
            }
            
        }
        return count <= 120
    }
    
    
    
   
    
    
    
    @IBAction func AddReviewAction(_ sender: Any) {
        let userReviewData = ["Restaurant Type":restaurantTypeValue!,"Restaurant Name":restaurantNameValue!,"ID":String(restaurantID!),"Review":userReviewValue!]
        guard let url = URL(string:"http://127.0.0.1:5000/api/getReview") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userReviewData, options:[]) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                DispatchQueue.main.async { // Correct
                self.ConfirmationLabel.text = "تم إضافة تعليقك بنجاح"
                }
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch  {
                    print(error)
                }
            }
        }.resume()
    }
}
    
    
    
    
    

    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


