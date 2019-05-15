//
//  mainPageControllerViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/9/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Kanna
class mainPageControllerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var announcementTitle: UILabel!
    @IBOutlet weak var announcementContent: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var monitorTable: UITableView!
    var isloading:Bool = true
    var curTerm:String!
    var termList:[String]?
    var classID:[String]?
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    override func viewWillAppear(_ animated: Bool) {
       
        if #available(iOS 11.0, *)
        {
            navigationItem.hidesSearchBarWhenScrolling = false
            
            
        }
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        isloading = true
        print("viewWillAppear232323")
        
       reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        print("")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentTerm()
        self.announcementContent.isHidden = true
        self.announcementTitle.isHidden = true
        self.announcementTitle.text = "Now Supporting \(getCurrentTerm()) classes"
        self.announcementContent.text = "Tap the plus to get started"
        setupAddButton()
        isloading = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        monitorTable.delegate=self
        monitorTable.dataSource=self
        
        reloadData()

        // Do any additional setup after loading the view.
    }
    func getCurrentTerm()->String
    {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM"
        let formattedDate = format.string(from: date)
        if(Int(formattedDate)!<=6)
        {format.dateFormat = "YYYY"
            
            let currentYear = format.string(from: date)
            return "Fall \(currentYear)"
           
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            
        }
        else{
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date)
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(Int(currentYear)!+1)")
            return "Spring \(String(Int(currentYear)!+1))"
            
        }
    }
    func setupAddButton()
    {
        
        // Shadow and Radius
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = addButton.frame.height/2
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowPath = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.layer.cornerRadius).cgPath
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 1.0
    }
    func updateCourseStatus(courseName:String,term:String,index1:Int)
    {
        https://webapp4.asu.edu/catalog/classlist?t=2197&k=87660&k=87660&hon=F&promod=F&e=all&page=1
            if courseName.characters.count == 0 {
            
            self.monitorTable.reloadData()
        }
        else
        {
            
            let scopeString = term
            print(scopeString)
            let index = scopeString.index(scopeString.startIndex, offsetBy: 5)
            let mySubstring = scopeString[..<index] // Hello
            
            print("test2 \(mySubstring)")
            
            
            
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
            if(courseName.count>3)
            {
                let searchStart = courseName.index(courseName.startIndex, offsetBy: 0)
                let searchEnd = courseName.index(courseName.startIndex,offsetBy:3)
                searchTxt = String(courseName[searchStart..<searchEnd])
                let idStart = courseName.index(courseName.startIndex, offsetBy: 3)
                let idEnd = courseName.index(courseName.endIndex, offsetBy: 0)
                idTxt = "&n=\(String(courseName[idStart..<idEnd]))"
                
            }
            else
            {
                searchTxt = courseName
                idTxt = ""
            }
            
            // Hello
            var url = ""
            //print(mySubstring)
            if(mySubstring == "Fall ")
            {
                
                //url = "https://webapp4.asu.edu/catalog/myclasslistresults?t=2\(index4)7&s=\(searchTxt!)\(idTxt!.trim())&hon=F&promod=F&e=all&page=1"
                
                url = "https://webapp4.asu.edu/catalog/myclasslistresults?t=2\(index4)7&k=\(courseName)&k=\(courseName)&hon=F&promod=F&e=all&page=1"
                //print(url.trimmingCharacters(in:.whitespacesAndNewlines))
            }
            else
            {
                url = "https://webapp4.asu.edu/catalog/myclasslistresults?t=2\(index4)1&k=\(courseName)&k=\(courseName)&hon=F&promod=F&e=all&page=1"
                //print(url.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            print(url)
            Alamofire.request(url.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)).responseData
                {
                    response in
                    //debugPrint("All Response Info: \(response)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        //print("Data: \(utf8Text)")
                        if self.parseResult(html3: utf8Text).3[0].first == "0"
                        {
                        self.courseStatusList![index1] = "close"
                        }
                        else
                        {
                            self.courseStatusList![index1] = "open"
                        }
                        self.isloading = false
                        self.monitorTable.reloadData()
                        print("Start Reloading")
                        print(self.courseStatusList)
                       
                        
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
            print("start parse")
            if var doc:HTMLDocument? =
                
                try Kanna.HTML(html:html3, encoding: .utf8) {
                var bodyNode   = doc?.body
                
                if let inputNodes = bodyNode?.xpath("//td[1]") {
                    print(" parse classID")
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
                    print(" parse className")
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
                    print(" parse instructorlist")
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
                    print(" parse statuslist")
                    print(inputNodes)
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
    func reloadData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            self.termList = []
            self.classID = []
            self.className = []
            self.instructorlist = []
            self.courseStatusList = []
            let result = try context.fetch(request)
            var i = 0
            var isEmpy = 1
            for data in result as! [NSManagedObject] {
                
                isEmpy = 0
                self.classID?.append(data.value(forKey: "courseID") as! String)
                
                self.className?.append(data.value(forKey: "courseName") as! String)
                self.termList?.append(data.value(forKey: "courseTerm") as! String)
                print(data.value(forKey: "courseID") as! String,data.value(forKey: "courseTerm") as! String,data.value(forKey: "courseStatus") as! String)
                self.instructorlist?.append(data.value(forKey: "instructorInfo") as! String)
               // checkCourseStatus(classID,className)
                
                self.courseStatusList?.append(data.value(forKey: "courseStatus") as! String)
                updateCourseStatus(courseName: data.value(forKey: "courseID") as! String,term: data.value(forKey: "courseTerm") as! String,index1: i)
                i = i + 1
                print("finsh loading")
                
            }
            if isEmpy == 1
            {
                self.announcementContent.isHidden = false
                self.announcementTitle.isHidden = false
            }
            else
            {
                self.announcementContent.isHidden = true
                self.announcementTitle.isHidden = true
            }
            
        } catch {
            
            print("Failed")
        }
        monitorTable.reloadData()
        
        
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(classID?.count)
        return classID?.count ?? 0
        
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {//let cell  = tableView.dequeueReusableCell(withIdentifier: "courseDetailCell") as! courseDetailCell
        // let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier:)
        //let cell1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "courseCell") as! courseInfoCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "monitorTable") as! courseMonitorCellTableViewCell
        cell1.backgroundColor = UIColor.clear
        //let cell = Bundle.main.loadNibNamed("courseResultCell", owner: self, options: nil)
        cell1.accessoryType = .disclosureIndicator
        cell1.courseID.text = classID![indexPath.row]
        cell1.courseName.text = className![indexPath.row]
        cell1.instructorInfo.text = instructorlist![indexPath.row]
        
        cell1.termInfo.text = termList![indexPath.row]
        
        
        
        var current_status = self.courseStatusList?[indexPath.row] as! String
       if isloading == true
       {
        cell1.curStatus.isHidden = true
        cell1.courseStatusActivityView.startAnimating()
        cell1.courseStatusActivityView.isHidden = false
        }
        else
       {
        cell1.curStatus.isHidden = false
        cell1.courseStatusActivityView.stopAnimating()
        cell1.courseStatusActivityView.isHidden = true
        if(current_status == "close")
        {
            var image : UIImage = UIImage(named: "close_final")!
            
            cell1.curStatus.image = image
        }
        else{
            var image : UIImage = UIImage(named: "open_final")!
            
            cell1.curStatus.image = image
        }
        }
        
        return cell1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("delete")
           deleteData("Entity",self.classID![indexPath.row])
            self.termList?.remove(at: indexPath.row)
            self.classID?.remove(at: indexPath.row)
            self.className?.remove(at: indexPath.row)
            self.instructorlist?.remove(at: indexPath.row)
            self.courseStatusList?.remove(at: indexPath.row)
            monitorTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func deleteData(_ entity:String,_ classID:String) {
            // Initialize Fetch Request
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            //request.predicate = NSPredicate(format: "age = %@", "12")
            request.returnsObjectsAsFaults = false
            
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { (result:NSAsynchronousFetchResult) in
                
                
                
                //对返回的数据做处理。
                
                let fetchObject = result.finalResult! as! [Entity]
                
                for c in fetchObject{
                    if c.courseID == classID
                    {
                        context.delete(c)
                    }
                    
                    
                    //所有删除信息
                    
                    
                    
                }
                
                appDelegate.saveContext()
                
            }
            
            
            
            // 执行异步请求调用execute
            
            do {
                
                try context.execute(asyncFetchRequest)
                
            } catch  {
                
                print("error")
                
            }
            
    }
        
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
