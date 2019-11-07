//
//  getCourseInfo.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 7/15/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
class getCourseInfos {
    var classID:[String]?
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    var isFinished:Bool?
    init(isload:Bool) {
        self.classID?.append("")
        self.className?.append("")
        self.instructorlist?.append("")
        self.courseStatusList?.append("")
        self.isFinished = false
    
    }
    
    
    public func parseResult(html3:String)->([String],[String],[String],[String])
    {
        var classID: [String] = []
        var className: [String] = []
        var instructorlist: [String] = []
        var statuslist: [String] = []
        do{
            if var doc:HTMLDocument? =
                
                try Kanna.HTML(html:html3, encoding: .utf8) {
                var bodyNode   = doc?.body
                if let inputNodes = bodyNode?.xpath("//td[1]") {
                    for node in inputNodes {
                        //print(node.content)
                        let node2String = node.content
                        if (node2String?.trim() != "")
                        {
                            classID.append(node2String?.trim() ?? "Unknown")
                        }
                    }
                    
                }
                if let inputNodes = bodyNode?.xpath("//td[3]") {
                    for node in inputNodes {
                        //print(node.content)
                        let node2String = node.content
                        if (node2String?.trim() != "")
                        {
                            className.append(node2String?.trim() ?? "Unknown")
                        }
                    }
                    
                }
                if let inputNodes = bodyNode?.xpath("//td[4]") {
                    for node in inputNodes {
                        //print(node.content)
                        let node2String = node.content
                        if (node2String?.trim() != "")
                        {
                            instructorlist.append(node2String?.trim() ?? "Unknown")
                        }
                    }
                    
                }
                if let inputNodes = bodyNode?.xpath("//td[11]") {
                    for node in inputNodes {
                        //print(node.content)
                        let node2String = node.content
                        if (node2String?.trim() != "")
                        {
                            
                            statuslist.append(node2String?.trim() ?? "Unknown")
                        }
                    }
                    
                }
            }
            
        }
        catch{
            return (["no class found"],[""],[""],[""])
            
        }
        return (classID,className,instructorlist,statuslist)
        
    }
    
    
    func search(searchText:String,courseResult:UITableView,searchController:UISearchController,faliureInfos:UILabel,activityIndicator:UIActivityIndicatorView,completionHandler: @escaping (_ classID: [String],_ className: [String],_ instructorlist: [String],_ courseStatusList: [String]) -> Void)   {
        self.isFinished = false
        if searchText.characters.count == 0 {
            //searching = false;
            
            courseResult.reloadData()
            //preturn (self.className ?? [],self.classID ?? [],self.instructorlist ?? [],self.courseStatusList ?? [])
        }
        else
        {
            
           let scopeString = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex]
            print(scopeString)
            let index = scopeString!.index(scopeString!.startIndex, offsetBy: 5)
            let mySubstring = scopeString![..<index] // Hello
            
            print("test2 \(mySubstring)")
            
            
            //searchController.searchBar.scopeBarButtonTitleTextAttributes(for:)
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date) as String?
            /*
             let index2 = currentYear!.index(currentYear!.startIndex, offsetBy: 2)
             let index3 = currentYear!.index(currentYear!.startIndex, offsetBy: 4)
             */
            let index2 = scopeString!.endIndex
            let index3 = scopeString!.index(scopeString!.endIndex, offsetBy: -2)
            let index4 = scopeString![index3..<index2]
            
            print(index4)
            var searchTxt:String?
            var idTxt:String?
            if(searchText.count>3)
            {
                let searchStart = searchText.index(searchText.startIndex, offsetBy: 0)
                let searchEnd = searchText.index(searchText.startIndex, offsetBy: 3)
                searchTxt = String(searchText[searchStart..<searchEnd])
                let idStart = searchText.index(searchText.startIndex, offsetBy: 3)
                let idEnd = searchText.index(searchText.endIndex, offsetBy: 0)
                idTxt = "&n=\(String(searchText[idStart..<idEnd]))"
                
            }
            else
            {
                searchTxt = searchText
                idTxt = ""
            }
            
            // Hello
            var url = ""
            print(mySubstring)
            if(mySubstring == "Fall ")
            {
                url = "https://webapp4.asu.edu/catalog/myclasslistresults?t=2\(index4)7&s=\(searchTxt!)\(idTxt!.trim())&hon=F&promod=F&e=all&page=1"
                print(url.trimmingCharacters(in:.whitespacesAndNewlines))
            }
            else
            {
                url = "https://webapp4.asu.edu/catalog/myclasslistresults?t=2\(index4)1&s=\(searchTxt!)\(idTxt!.trim())&hon=F&promod=F&e=all&page=1"
                print(url.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            Alamofire.request(url.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)).responseData
                {
                    response in
                    //debugPrint("All Response Info: \(response)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        //print("Data: \(utf8Text)")
                        self.classID = self.parseResult(html3: utf8Text).0
                        self.className = self.parseResult(html3: utf8Text).1
                        self.instructorlist = self.parseResult(html3: utf8Text).2
                        self.courseStatusList = self.parseResult(html3: utf8Text).3
                        if(self.classID!.count == 0){
                            //self.searching = false;
                            faliureInfos.text = "No class found!"
                            activityIndicator.stopAnimating()
                            faliureInfos.isHidden = false
                            courseResult.reloadData()
                        } else
                        {
                            faliureInfos.isHidden = true
                            //self.searching = true;
                            courseResult.reloadData()
                        }
                        
                        completionHandler(self.classID ?? [],self.className ?? [],self.instructorlist ?? [],self.courseStatusList ?? [])
                        
                       
                        
                        //td[1]
                    }
            }
           
            print(self.className)
            //return (self.className ?? [],self.classID ?? [],self.instructorlist ?? [],self.courseStatusList ?? [])
            
        }
        
    }
    
}
