//
//  statusViewController.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 12/3/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

//

import UIKit
import Charts
class statusViewController: UIViewController {

    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var inputText: UITextField!
    var numbers : [Double] = []
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
      

        // Do any additional setup after loading the view.
    }
    
    @IBAction func update(_ sender: Any) {
        let input  = Double(inputText.text!) //gets input from the textbox - expects input as double/int

        numbers.append(input!) //here we add the data to the array.
        updateGraph()
    }
    func updateGraph(){
           var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.

           
           
           //here is the for loop
           for i in 0..<numbers.count {

               let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry

               lineChartEntry.append(value) // here we add it to the data set
           }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet

           line1.colors = [NSUIColor.blue] //Sets the colour to blue

        line1.circleHoleRadius = CGFloat(2)
        line1.circleRadius = CGFloat(4)
           let data = LineChartData() //This is the object that will be added to the chart

           data.addDataSet(line1) //Adds the line to the dataSet
           

           chtChart.data = data //finally - it adds the chart data to the chart and causes an update

           chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph

       }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
