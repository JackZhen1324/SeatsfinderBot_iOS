//
//  ViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/8/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
class ViewController: UIViewController {

    @IBOutlet weak var faliureInfos: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var courseResult: UITableView!
    var curRes:String!
    var curCell: courseInfoCell?
    var curTerm:String!
    var termList = ["Pre-Term"]
    var classID:[String]?
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    var searching:Bool?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *)
        {
            
            navigationItem.hidesSearchBarWhenScrolling = false
            
           
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.faliureInfos.isHidden = true
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        courseResult.separatorStyle = .none
        classID?.append("id1")
        className?.append("name1")
        instructorlist?.append("instrcutor1")

        courseResult.reloadData()
        courseResult.delegate = self
        courseResult.dataSource = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Course #CSE110"
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.autocapitalizationType = .allCharacters
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.barTintColor = UIColor.init(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM"
        let formattedDate = format.string(from: date)
        if(Int(formattedDate)!<=6)
        {format.dateFormat = "YYYY"
        self.termList = []
        let currentYear = format.string(from: date)
            termList.append("Fall \(Int(currentYear)!-1)")
            termList.append("Spring \(currentYear)")
            termList.append("Fall \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            
        }
        else{
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date)
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(Int(currentYear)!+1)")
            termList.append("Spring \(currentYear)")
            termList.append("Fall \(currentYear)")
            termList.append("Spring \(Int(currentYear)!+1)")
        }
        searchController.searchBar.scopeButtonTitles = termList
        
      
     
        //let nib = UINib.init(nibName:"courseDetailCell",bundle:nil)
        //self.courseResult.register(nib, forCellReuseIdentifier: "courseDetailCell")
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    public func getCourseInfo(searchText:String)
    {
        if searchText.characters.count == 0 {
            searching = false;
            self.courseResult.reloadData()
            
        }
        else
        {
            
            guard let scopeString = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex] else { return }
            print(scopeString)
            let index = scopeString.index(scopeString.startIndex, offsetBy: 5)
            let mySubstring = scopeString[..<index] // Hello
            
            print("test2 \(mySubstring)")
            
           
            searchController.searchBar.scopeBarButtonTitleTextAttributes(for:)
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date) as String?
            
            let index2 = currentYear!.index(currentYear!.startIndex, offsetBy: 2)
            let index3 = currentYear!.index(currentYear!.startIndex, offsetBy: 4)
            let index4 = currentYear![index2..<index3]
            
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
                        print("Data: \(utf8Text)")
                        self.classID = self.parseResult(html3: utf8Text).0
                        self.className = self.parseResult(html3: utf8Text).1
                        self.instructorlist = self.parseResult(html3: utf8Text).2
                        self.courseStatusList = self.parseResult(html3: utf8Text).3
                        if(self.classID!.count == 0){
                            self.searching = false;
                            self.faliureInfos.text = "No class found!"
                            self.activityIndicator.stopAnimating()
                            self.faliureInfos.isHidden = false
                            self.courseResult.reloadData()
                        } else
                        {
                            self.faliureInfos.isHidden = true
                            self.searching = true;
                            self.courseResult.reloadData()
                        }
                        
                        
                        
                        print("hellp")
                        
                        //td[1]
                    }
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail"
        {
            let destController = segue.destination as! overViewController
            
           
            var blogIndex = courseResult.indexPathForSelectedRow?.row
            print(className![blogIndex!])
            var test = className![blogIndex!]
            destController.className_ = className![blogIndex!]  as String
            destController.classID_ = classID![blogIndex!]  as String
            destController.instructor_ = instructorlist![blogIndex!]  as String
             destController.term = curTerm  as String
            
            
        }
    }
 
    

}
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        curCell = tableView.cellForRow(at: indexPath!) as! courseInfoCell
        curRes = "help"
        print(curRes!)
        
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return classID?.count ?? 0
        
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {//let cell  = tableView.dequeueReusableCell(withIdentifier: "courseDetailCell") as! courseDetailCell
        // let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier:)
        //let cell1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "courseCell") as! courseInfoCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! courseInfoCell
        //let cell = Bundle.main.loadNibNamed("courseResultCell", owner: self, options: nil)
        
        cell1.accessoryType = .disclosureIndicator
        cell1.courseID.text = classID?[indexPath.row]
        cell1.courseName.text = className?[indexPath.row]
        cell1.instructorIndo.text = instructorlist?[indexPath.row]
        cell1.termInfo.text = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        curTerm = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        var current_status = self.courseStatusList?[indexPath.row] as! String
        if(current_status.first == "0")
        {
            var image : UIImage = UIImage(named: "closed_final3")!
            
            cell1.courseStatus.image = image
        }
        else{
            var image : UIImage = UIImage(named: "open_final4")!
            
            cell1.courseStatus.image = image
        }
        print("stop animating")
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        return cell1
    }
    
}
extension ViewController: UISearchBarDelegate{
   
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let scopeString = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex] else { return }
        print(scopeString)
        getCourseInfo(searchText:searchController.searchBar.text!)
        print("change scope")
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("start typing")
        searching = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end typing")
        searchBar.resignFirstResponder()
        searching = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchController.searchBar.showsCancelButton = false
        
        print("search click")
        searching = false;
    }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        print("searching")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getCourseInfo(searchText: searchBar.text!)
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
        searching = false;
    }
    
    
    
    
}




