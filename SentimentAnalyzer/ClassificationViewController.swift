//
//  ClassificationViewController.swift
//  SentimentAnalyzer
//
//  Created by Islam Elsayed on 6/11/19.
//  Copyright © 2019 Islam Elsayed. All rights reserved.
//

import UIKit
import Charts// for data visualization
import Macaw
import SwiftyJSON // json parsing
class ClassificationViewController: UIViewController {
 
    @IBOutlet weak var returnToHomeeBtn: UIButton!
    
    @IBOutlet weak var barChart: BarChartView!
    
    let models = ["SVM","Naive Bayes","Logistic Regression"]
    var SVM : Double = 0.0
    var NB : Double = 0.0
    var LR : Double = 0.0
    var modelsVals = [Double]()
    var myAccData : JSON? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SVM = 30.0
        self.NB = 10.0
        self.LR = 40.0
        self.modelsVals = [self.SVM,self.NB,self.LR]
        setChart( values: modelsVals)
    }
    func setChart( values: [Double]) {
        barChart.noDataText = "You need to provide data for the chart."
        var SVMdataEntries: [BarChartDataEntry] = []
        var NBdataEntries: [BarChartDataEntry] = []
        var LRMdataEntries: [BarChartDataEntry] = []
        
   
        let SVMdataEntry = BarChartDataEntry(x: Double(0), yValues: [values[0]])
        let NBdataEntry = BarChartDataEntry(x: Double(1), yValues: [values[1]])
        let LRdataEntry = BarChartDataEntry(x: Double(2), yValues: [values[2]])
            SVMdataEntries.append(SVMdataEntry)
            NBdataEntries.append(NBdataEntry)
            LRMdataEntries.append(LRdataEntry)
        
        let SVMchartDataSet = BarChartDataSet(entries: SVMdataEntries, label: "SVM")
        let NBchartDataSet = BarChartDataSet(entries: NBdataEntries, label: "Naive Bayes")
        let LRchartDataSet = BarChartDataSet(entries: LRMdataEntries, label: "Logistic Regression")
        let chartData = BarChartData(dataSets: [SVMchartDataSet,NBchartDataSet,LRchartDataSet])
        chartData.setDrawValues(true)
        
        let SVMcolors = [UIColor(named: "SVM")]
        SVMchartDataSet.colors = SVMcolors as! [NSUIColor]
        let NBcolors = [UIColor(named: "Naive Bayes")]
        NBchartDataSet.colors = NBcolors as! [NSUIColor]
        let LRcolors = [UIColor(named: "Logistic Regression")]
        LRchartDataSet.colors = LRcolors as! [NSUIColor]
        
        
        barChart.data = chartData
        barChart.backgroundColor = UIColor.white
    }
    
  
    @IBAction func getAccuracy(_ sender: Any) {
        guard let url = URL(string:"http://127.0.0.1:5000/api/getAccuracyData") else {return}
        getAccuracyFromPY(url:url)
    }
    private func getAccuracyFromPY(url:URL){
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response{
                print(response)
            }
            
            if let data = data{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.myAccData = JSON(json)
                    print(self.myAccData ?? 0)
                    DispatchQueue.main.async {
                        if(self.barChart.isHidden == true){
                            self.barChart.isHidden = false
                            self.returnToHomeeBtn.isHidden = false
                            self.SVM = self.myAccData?["SVM"].double ?? 0
                            self.NB = self.myAccData?["NaiveBayes"].double ?? 0
                            self.LR = self.myAccData?["LogisitcRegression"].double ?? 0
                            self.modelsVals[0]=(self.SVM*100)
                            self.modelsVals[1]=(self.NB*100)
                            self.modelsVals[2]=(self.LR*100)
                            print(self.SVM)
                            self.setChart(values: self.modelsVals)
                        }
                        
                        
                    }
                   
                }catch {
                    print(error)
                }
            }
            }.resume()
    }




}
