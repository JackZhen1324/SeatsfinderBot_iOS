//
//  monitoringData.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 7/16/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//




import UIKit
import CoreData
import Alamofire
import Kanna

import SwiftyJSON

class monitoring_utils {
    
    var curLo = [String](repeatElement("", count: 10))
    var jobs=[String](repeatElement("", count: 10))
    var mode=[String](repeatElement("", count: 10))
    var count=[Int](repeatElement(0, count: 10))
    var courseID = [String](repeatElement("", count: 10))
    
    var isChecking:String?
    var logs:String?
    var curJobID:String?
    var currentMode:String?
    var currentCount:String?
    var currentID:String?
    
    var currentSelect = 0
    var isloading:Bool = true
    var curTerm:String!
    var jobidList:[String]?
    var termList:[String]?
    var classID:[String]?
    
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    var asuID:[String]?
    
    
    
    
    
    
    func reloadData(monitorTable:UITableView,refreshControl:UIRefreshControl,completion:((_ success: Bool)->Void)?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        
        
        do {
            
            let result = try context.fetch(request)
            var i = 0
            let currentUSER = UserDefaults.standard.string(forKey: "asuID") ?? "Unknown"
            getAllCourseInfo(asuID: currentUSER,monitorTable:monitorTable,refreshControl:refreshControl)
            
            
        } catch {
            
            print("Failed")
        }
        monitorTable.reloadData()
        
        
        
        
    }
    
    
    
    func getAllCourseInfo(asuID:String,monitorTable:UITableView,refreshControl:UIRefreshControl) {
        var data = ["asuID":asuID]
        
        //print(data)
        
        var url = "http://68.225.193.31:8000/fetchAllCourse/"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                print("SUCCESS6")
                //print(response.result.value)
                do{
                    var json = try JSON(data: response.data!)
                    print(json)
                    
                    print("###################################")
                    var i = 0
                    //print(json["message"])
                    for (index,subJson):(String, JSON) in json {
                        // Do something you want
                        //print(subJson["courseID"].string,subJson["section"].string)
                        print(subJson["jobId"].string)
                        self.jobidList?.append(subJson["jobId"].string ?? "Unknown")
                        
                        
                        print("\(index) classIDtEST")
                        print(self.classID)
                        if(self.classID?.contains(subJson["coueseId"].string ?? "Unknown")==true)
                        {}
                        else
                        {
                            self.className?.append(subJson["courseID"].string ?? "Unknown")
                            //self.asuID?.append(subJson["user"].string ?? "Unknown")
                            self.classID?.append(subJson["coueseId"].string ?? "N/A")
                            var temSemester = subJson["semester"].string ?? "N/A"
                            self.termList?.append(temSemester.replacingOccurrences(of: "+", with: " "))
                            //print(data.value(forKey: "courseID") as! String,data.value(forKey: "courseTerm") as! String,data.value(forKey: "courseStatus") as! String)
                            self.instructorlist?.append( subJson["instructor"].string ?? "N/A")
                            // checkCourseStatus(classID,className)
                            self.asuID?.append(subJson["user"].string ?? "Unknown User")
                            print(subJson["logs"].string)
                            if(subJson["logs"].string?.last == "L")
                            {
                                print(self.courseStatusList)
                                print("after****************")
                                self.courseStatusList?.append("close")
                                print(self.courseStatusList)
                            }
                            else
                            {
                                self.courseStatusList?.append("open")
                            }
                            
                            //print("test\(self.courseStatusList)")
                        }
                        monitorTable.reloadData()
                        //self.updateCourseStatus(courseName: subJson["section"].string ?? "N/A",term: subJson["semester"].string ?? "UnknownTerm",index1: i)
                        i = i + 1
                        
                    }
                    
                    
                    refreshControl.endRefreshing()
                    self.isloading = false
                    
                    
                    
                }
                catch{
                    print("invalid ")
                    refreshControl.endRefreshing()
                    self.isloading = false
                    
                }
            case .failure:
                refreshControl.endRefreshing()
                self.isloading = false
                print("ERROR")
                
                
            }
        }
    }
}
        
        
        
    
    








