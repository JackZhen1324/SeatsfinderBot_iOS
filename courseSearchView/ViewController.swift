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
    
    var classID:[String]?
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    let searching = loadingController(isload: false)
    let searchCourse = getCourseInfos(isload: false)
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
        searchController.searchBar.scopeButtonTitles = getTerms.getTerms()

    
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
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
        
        //cell1.accessoryType = .disclosureIndicator
        cell1.courseID.text = classID?[indexPath.row]
        cell1.courseName.text = className?[indexPath.row]
        cell1.instructorIndo.text = instructorlist?[indexPath.row]
        cell1.termInfo.text = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        curTerm = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        var current_status = self.courseStatusList?[indexPath.row] as! String
        if(current_status.first == "0")
        {
            var image : UIImage = UIImage(named: "open_5")!
            
            
            cell1.courseStatus.image = image
        }
        else{
            var image : UIImage = UIImage(named: "closed_5")!
           
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
        let result = self.searchCourse.search(searchText: searchController.searchBar.text!, courseResult: self.courseResult, searchController: self.searchController, faliureInfos: self.faliureInfos!, activityIndicator: self.activityIndicator){
            classID,className,instructorlist,courseStatusList in
            self.classID = classID
            self.className = className
            self.instructorlist = instructorlist
            self.courseStatusList = courseStatusList
            
            self.courseResult.reloadData()
            
        }
  
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("start typing")
        searching.setLoadingStatus(isload: true);
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end typing")
        searchBar.resignFirstResponder()
        searching.setLoadingStatus(isload: false);
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchController.searchBar.showsCancelButton = false
        
        print("search click")
        searching.setLoadingStatus(isload: false);
    }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        print("searching")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let result = self.searchCourse.search(searchText: searchController.searchBar.text!, courseResult: self.courseResult, searchController: self.searchController, faliureInfos: self.faliureInfos!, activityIndicator: self.activityIndicator){
            classID,className,instructorlist,courseStatusList in
            self.classID = classID
            self.className = className
            self.instructorlist = instructorlist
            self.courseStatusList = courseStatusList
            print("")
            print(classID)
            self.courseResult.reloadData()
            
        }
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
        searching.setLoadingStatus(isload: false);
    }
    
    
    
    
}




