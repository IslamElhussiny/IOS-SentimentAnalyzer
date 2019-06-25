//
//  ForthViewController.swift
//  The Night Porter
//
//  Created by Islam Elsayed on 5/11/19.
//  Copyright © 2019 Islam Elsayed. All rights reserved.
//

import UIKit
import Charts// for data visualization
import SwiftyJSON // json parsing
class ForthViewController:  UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var resTypeTB: UITextField!
    @IBOutlet weak var firstRes: UILabel!
    @IBOutlet weak var secondRes: UILabel!
    @IBOutlet weak var thirdRes: UILabel!
    @IBOutlet weak var firstResWeight: UILabel!
    @IBOutlet weak var secondResWeight: UILabel!
    @IBOutlet weak var thirdResWeight: UILabel!
    @IBOutlet weak var showCommentsBtn: UIButton!
    var resTypeValue : String!
    @IBOutlet weak var resTB : UITextField!
    var resNameValue : String!
    var restaurantID : Int!
    
    @IBOutlet weak var firstRankLabel: UILabel!
    @IBOutlet weak var secondRankLabel: UILabel!
    @IBOutlet weak var thirdRankLabel: UILabel!
    
    @IBOutlet weak var commentsScrollView: UIScrollView!
    @IBOutlet weak var commentsTextView: UITextView!
    // restaurants type lists
    var resType = ["هندي","شرقي","غربي"]
    var indian = ["مطعم ساشي","Gad-جاد","Pane Vino- بانيه فينو"]
    var sharki = ["Pane Vino- بانيه فينو","Zaitouni-زيتوني","Majesty"]
    var western = ["Majesty","Peking","Tesppas"]
    let resTypePV = UIPickerView()
    let resPV = UIPickerView()
    
    var mydata : JSON? = nil // global json var to get json from python
    //var dataRecieved : JSON? = nil // json recieved from first view controller
    var commentsData : JSON? = nil
    var weight : JSON? = nil // part of json content
    var stats =  Dictionary<String, JSON>() // restaurant statistics json second content part
    var statsKeys = Array<Any>() // the keys to be printed as values individually
    var statsVals = Array<Any>()
    var ranks : JSON? = nil // the rank of each restaurant , third json content part
    
    @IBOutlet weak var pieChart: PieChartView!
    var positiveDataEntry = PieChartDataEntry(value: 0)
    var negativDataEntry = PieChartDataEntry(value: 0)
    var neutralDataEntry = PieChartDataEntry(value: 0)
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ابحث عن نوعك المفضل"
        
        resTypePV.delegate = self
        resTypePV.tag = 1
        resTypeTB.inputView = resTypePV
        
        resPV.delegate = self
        resPV.tag = 2
        resTB.inputView = resPV
        
        pieChart.chartDescription?.text = "Polarity Pie Chart"
        positiveDataEntry.value = 50
        positiveDataEntry.label = "إيجابي"
        negativDataEntry.value = 50
        negativDataEntry.label = "سلبي"
        neutralDataEntry.value = 50
        neutralDataEntry.label = "محايد"
        numberOfDownloadsDataEntries = [positiveDataEntry,negativDataEntry,neutralDataEntry]
        updateChartData()
        
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
                resTypeValue = resTypeTB.text!
                resTB.text = indian[row]
                resNameValue = resTB.text!
                if resNameValue == "ساشي"{
                    restaurantID = 101
                }
                else if resNameValue == "Gad-جاد"{
                    restaurantID = 102
                }
                else if resNameValue == "Pane Vino- بانيه فينو"{
                    restaurantID = 103
                }
                print(resTypeValue!)
                print(resNameValue!)
                print(restaurantID!)
                self.view.endEditing(true)
            }
            else if resTypeTB.text == "شرقي"{
                resTypeValue = resTypeTB.text!
                resTB.text = sharki[row]
                resNameValue = resTB.text!
                if resNameValue == "Pane Vino- بانيه فينو"{
                    restaurantID = 103
                }
                else if resNameValue == "Zaitouni-زيتوني"{
                    restaurantID = 104
                }
                else if resNameValue == "Majesty"{
                    restaurantID = 105
                }
                print(resTypeValue!)
                print(resNameValue!)
                print(restaurantID!)
                self.view.endEditing(true)
            }
            else if resTypeTB.text == "غربي"{
                resTypeValue = resTypeTB.text!
                resTB.text = western[row]
                resNameValue = resTB.text!
                if resNameValue == "Majesty"{
                    restaurantID = 105
                }
                else if resNameValue == "Peking"{
                    restaurantID = 106
                }
                else if resNameValue == "Tesppas"{
                    restaurantID = 107
                }
               self.view.endEditing(true)
            }
        }
    }
        
    var counter : Int = 0
    @IBAction func onTappedSearch(_ sender: Any) {
        guard let url = URL(string:"http://127.0.0.1:5000/api/queryWithResType") else {return}
        if (self.commentsScrollView.isHidden==false){
            self.commentsScrollView.isHidden = true
        }
        searchForMyQuery(url: url)
        counter+=1
    }
    
    
    private func resetaAllUI (){
        self.firstRes.isHidden = true
        self.firstResWeight.isHidden = true
        self.firstRankLabel.isHidden = true
        self.secondRes.isHidden = true
        self.secondResWeight.isHidden = true
        self.secondRankLabel.isHidden = true
        self.thirdRes.isHidden = true
        self.thirdResWeight.isHidden = true
        self.thirdRankLabel.isHidden = true
        self.pieChart.isHidden = true
    }
    
    @IBAction func onTappedShowComments(_ sender: Any) {
        guard let url = URL(string:"http://127.0.0.1:5000/api/showComments") else {return}
        self.resetaAllUI()
        retriveComments(url:url)
    }
    
    
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)
        let charData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor(named: "Positive"),UIColor(named: "Negative"),UIColor(named: "Neutral")]
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = charData
        pieChart.backgroundColor = UIColor.white
    }
  
    private func retriveComments(url:URL){
        let userQuery = ["Restaurant Type":self.resTypeValue!,"Restaurant Name":self.resNameValue!,"ID":String(self.restaurantID!)]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userQuery, options:[]) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    self.commentsData = JSON(json)
                    DispatchQueue.main.async {
                        if(self.commentsScrollView.isHidden==true){
                            self.commentsScrollView.isHidden=false
                            if(self.commentsTextView.isHidden == true){
                                self.commentsTextView.isHidden = false
                                let lineStrip: String = "______________________________________________________"
                                for posComment in (self.commentsData?["PositiveComments"].array)!{
                                    self.commentsTextView.text += String("•"+posComment.stringValue+"\n"+lineStrip)
                                }
                                for negComment in (self.commentsData?["NegativeComments"].array)!{
                                    self.commentsTextView.text += String("•"+negComment.stringValue+"\n"+lineStrip)
                                }
                            }
                        }
                    }
                }catch  {
                    print(error)
                }
                //self.performSegue(withIdentifier:"sendDataToVC", sender: self)
            }
            }.resume()
        }
    private func searchForMyQuery(url:URL){
        let userQuery = ["Restaurant Type":self.resTypeValue!,"Restaurant Name":self.resNameValue!,"ID":String(self.restaurantID!)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userQuery, options:[]) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.mydata = JSON(json)
                    print("Wait for json")
                    self.ranks = self.mydata?["Ranking"]
                    print(self.ranks?[0][0].stringValue ?? "")
                    self.weight = self.mydata?["Overall Weight"]
                    print(self.weight ?? 0)
                    self.stats = self.mydata?["Statistics"].dictionary ?? ["":0]
                    print(self.stats)
                    self.statsKeys = Array((self.stats.keys))
                    self.statsVals = Array(self.stats.values)
                    print(self.statsKeys)
                    print(self.statsKeys[0],self.statsVals[0]) // Neutral is index 0
                    print(self.statsKeys[1],self.statsVals[1]) // Negative is index 1
                    print(self.statsKeys[2],self.statsVals[2]) // Positive is index 2
                    self.ranks = self.mydata?["Ranking"]
                    DispatchQueue.main.async { // Correct
                        // First restaurant data name and weight
                        
                        if(self.firstRes.isHidden == true || self.counter>=1){
                            self.firstRes.isHidden = false
                            self.firstRes.text = self.ranks?[0][0].stringValue
                            if(self.firstResWeight.isHidden == true || self.counter>=1){
                                self.firstResWeight.isHidden = false
                                self.firstResWeight.text = self.ranks?[0][1].stringValue
                            }
                            if (self.firstRankLabel.isHidden == true || self.counter>=1){
                                self.firstRankLabel.isHidden = false
                            }
                        }
                        
                        // Second restaurant data name and weight
                        if(self.secondRes.isHidden == true || self.counter>=1){
                            self.secondRes.isHidden = false
                             self.secondRes.text = self.ranks?[1][0].stringValue
                            if(self.secondResWeight.isHidden == true || self.counter>=1){
                                self.secondResWeight.isHidden = false
                                self.secondResWeight.text = self.ranks?[1][1].stringValue
                            }
                            if (self.secondRankLabel.isHidden == true || self.counter>=1){
                                self.secondRankLabel.isHidden = false
                            }
                        }
                        // third restaurant data name and weight
                        if(self.thirdRes.isHidden == true || self.counter>=1){
                            self.thirdRes.isHidden = false
                            self.thirdRes.text = self.ranks?[2][0].stringValue
                            if(self.thirdResWeight.isHidden == true || self.counter>=1){
                                self.thirdResWeight.isHidden = false
                                self.thirdResWeight.text = self.ranks?[2][1].stringValue
                            }
                            if (self.thirdRankLabel.isHidden == true || self.counter>=1){
                                self.thirdRankLabel.isHidden = false
                            }
                        }
                        
                        if(self.pieChart.isHidden == true || self.counter>=1){
                            self.pieChart.isHidden = false
                            self.positiveDataEntry.value = self.mydata?["Statistics"]["Positive"].double ?? 0
                            self.negativDataEntry.value = self.mydata?["Statistics"]["Negative"].double ?? 0
                            self.neutralDataEntry.value = self.mydata?["Statistics"]["Neutral"].double ?? 0
                            self.pieChart.chartDescription?.text = ("مجموع النقاط: " + self.weight!.stringValue )
                            self.updateChartData()
                        }
                        if(self.showCommentsBtn.isHidden == true || self.counter>=1){
                            self.showCommentsBtn.isHidden = false
                        }
                    }
                    
                }catch  {
                    print(error)
                }
                
            }
            }.resume()
    }
    
    
    
}


