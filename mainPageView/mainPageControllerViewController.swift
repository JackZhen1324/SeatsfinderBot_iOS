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
import FirebaseDatabase
import Firebase
import SwiftyJSON
class mainPageControllerViewController: UIViewController {
   
    @IBOutlet weak var currentUserName: UILabel!
    
    @IBOutlet weak var logviewTestCell: UITableViewCell!
    
    
    
    @IBOutlet weak var hideView: UIView!
   
    @IBOutlet weak var currentUserView: UIView!
    @IBOutlet weak var logView: UIView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var announcementTitle: UILabel!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var announcementContent: UILabel!
    var lock:Int = 1
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var monitorTable: UITableView!
    @IBOutlet weak var logViewHeight: NSLayoutConstraint!
    var isChecking:String?
    var logs:String?
    var curJobID:String?
    var currentMode:String?
    var currentCount:String?
    var currentID:String?
    
    var isloading:Bool = true
    var curTerm:String!
    var jobidList:[String]?
    var termList:[String]?
    var classID:[String]?
    var className:[String]?
    var instructorlist:[String]?
    var courseStatusList:[String]?
    var asuID:[String]?
    override func viewWillAppear(_ animated: Bool) {
       showCurrentUser()
        if #available(iOS 11.0, *)
        {
            navigationItem.hidesSearchBarWhenScrolling = true
            
            
        }
        super.viewWillAppear(animated)
        
        isloading = true
        //print("viewWillAppear232323")
        
       reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCurrentUser()
        
        print("是否第一次运行？\(UserDefaults.isFirstLaunchOfNewVersion() )")
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.isFirstLaunchOfNewVersion()==true)
        {
            performSegue(withIdentifier: "goRgister", sender: Any?.self)
        }
        showCurrentUser()
        self.hideView.isHidden  = true
        
        self.isChecking = "1"
        
        logTableView.layer.cornerRadius = 10
        logTableView.layer.backgroundColor = UIColor.lightGray.cgColor
    
        
        
        setupTableView()
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        getCurrentTerm()
        self.announcementContent.isHidden = true
        self.announcementTitle.isHidden = true
        self.announcementTitle.text = "Now Supporting \(getCurrentTerm()) classes"
        self.announcementContent.text = "Tap the plus to get started"
        setupAddButton()
        isloading = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        logTableView.delegate = self
        logTableView.dataSource = self
        monitorTable.delegate=self
        monitorTable.dataSource=self
        tabBarController?.tabBar.barTintColor = UIColor.white
        self.logs = ""
        self.currentMode = ""
        self.currentCount = ""
        self.curJobID = ""
        self.currentID = ""
        reloadData()
       
        // Do any additional setup after loading the view.
    }
    func showCurrentUser()  {
        let currentUSER = UserDefaults.standard.string(forKey: "asuID") ?? "Unknow"
       self.currentUserName.text = "log in as \(currentUSER)"
        self.currentUserName.textColor = UIColor.clear
        self.currentUserView.backgroundColor = UIColor.clear
        currentUserView.layer.cornerRadius = 15
        UIView.animate(withDuration: 0.5, animations: {
            self.currentUserName.textColor = UIColor.white
            self.currentUserView.backgroundColor = UIColor.lightGray
            
        }, completion: { (Bool) in
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // UI Updates here for task complete.
            
           
            self.currentUserView.isHidden = true
            self.currentUserName.isHidden = true
            
        })
       
        
        
        
    }
    @IBAction func goSearchPage(_ sender: Any) {
        self.isChecking = "1"
        self.lock = 1
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchWeatherData()
    }
    private func fetchWeatherData() {
        
            DispatchQueue.main.async {
                self.isloading = true
                self.reloadData()
                self.refreshControl.endRefreshing()
                //self.activityIndicatorView.stopAnimating()
            }
        
    }
    
    func setupTableView()
    {
        if #available(iOS 10.0, *) {
            monitorTable.refreshControl = refreshControl
        } else {
            monitorTable.addSubview(refreshControl)
        }
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
            //print(scopeString)
            let index = scopeString.index(scopeString.startIndex, offsetBy: 5)
            let mySubstring = scopeString[..<index] // Hello
            
           // print("test2 \(mySubstring)")
            
            
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date) as String?
            
            let index2 = currentYear!.index(currentYear!.startIndex, offsetBy: 2)
            let index3 = currentYear!.index(currentYear!.startIndex, offsetBy: 4)
            let index4 = currentYear![index2..<index3]
            
            //print(index4)
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
            
            //print(url)
            Alamofire.request(url.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)).responseData
                {
                    response in
                    //debugPrint("All Response Info: \(response)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        //print("Data: \(utf8Text)")
                        do
                        {
                        if try self.parseResult(html3: utf8Text).3[0].first == "0"
                        {
                        self.courseStatusList![index1] = "close"
                        }
                        else
                        {
                            self.courseStatusList![index1] = "open"
                        }
                        self.isloading = false
                        self.monitorTable.reloadData()
                        //print("Start Reloading")
                        //print(self.courseStatusList)
                        }
                        catch
                        {
                            
                        }
                        
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
            //print("start parse")
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
                   // print(" parse statuslist")
                    //print(inputNodes)
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
            self.asuID = []
            self.jobidList = []
            let result = try context.fetch(request)
            var i = 0
            var isEmpy = 1
            for data in result as! [NSManagedObject] {
                
                isEmpy = 0
                self.jobidList?.append(data.value(forKey: "coutseTime") as! String)
                self.classID?.append(data.value(forKey: "courseID") as! String)
                self.asuID?.append(data.value(forKey: "courseTitle") as! String)
                self.className?.append(data.value(forKey: "courseName") as! String)
                self.termList?.append(data.value(forKey: "courseTerm") as! String)
                //print(data.value(forKey: "courseID") as! String,data.value(forKey: "courseTerm") as! String,data.value(forKey: "courseStatus") as! String)
                self.instructorlist?.append(data.value(forKey: "instructorInfo") as! String)
               // checkCourseStatus(classID,className)
                
                self.courseStatusList?.append(data.value(forKey: "courseStatus") as! String)
                print("current index: \(i)")
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

extension mainPageControllerViewController:UITableViewDataSource,UITableViewDelegate
{
    @objc public func pressed(sender:Any)
    {
        
        UIView.animate(withDuration: 1) {
            self.logTableView.layer.position = CGPoint(x: self.logTableView.frame.width/2, y: self.view.frame.origin.y+self.view.frame.height*1.2)
            self.hideView.backgroundColor = UIColor.init(displayP3Red: CGFloat(239.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(244.0/255.0), alpha: CGFloat(1))
            
        }
        self.hideView.isHidden = true
        self.isChecking = "0"
        self.lock = 1
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = tableView.frame
        let headerTitle:UILabel = UILabel(frame: CGRect(x: 10, y: 3, width: 150, height: 50))
        let DoneBut: UIButton = UIButton(frame: CGRect(x: self.view.bounds.width-80, y: 0, width: 100, height: 50))
        headerTitle.text = "LOGS"
        headerTitle.textColor = UIColor.white
        headerTitle.font = UIFont(name: "System", size: CGFloat(14))
        DoneBut.setTitle("x", for: .normal)
        DoneBut.backgroundColor = UIColor.clear
        
        DoneBut.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        let headerView: UIView = UIView(frame: CGRect(x:0,y: 0,width: frame.size.height,height:frame.size.width))
        
        headerView.addSubview(DoneBut)
        headerView.addSubview(headerTitle)
       
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
   
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEqual(logTableView)
        {
        }
        else
        {
       self.isChecking = "1"
            print("current:  \(isChecking)")
        if self.lock == 1
        {
            self.hideView.isHidden = false
            UIView.animate(withDuration: 1) {
                self.hideView.backgroundColor = UIColor.init(displayP3Red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
            }
        UIView.animate(withDuration: 1) {
            
            //self.logTableView.frame.size.width = self.view.frame.width
            self.logTableView.layer.position = CGPoint(x: self.logTableView.frame.width/2, y: self.view.frame.origin.y+self.view.frame.height-self.logTableView.frame.height*1.2)
            
            
        }
            DispatchQueue.global(qos: .background).async {
                while self.isChecking == "1"
                {   print(self.asuID)
                    print(indexPath.row)
                    //print(self.classID![indexPath.row])
                    do
                    {
                    try self.checkLogs(asuID: self.asuID![indexPath.row], courseID: self.classID![indexPath.row] )
                    sleep(1)
                    }
                    catch
                    {
                        print("check log fail")
                    }
                }
                
            }
            print(asuID)
            print(classID)
            checkLogs(asuID: self.asuID![indexPath.row], courseID: self.classID![indexPath.row] )
            self.lock = lock * -1
            }
            else
        {
            print("fail to retrive lock")
            }
            
        //print(self.logTableView.frame.height)
        }
        
        
    }
    func checkLogs(asuID:String,courseID:String)
    {
        
        var data = ["courseID":courseID,"asuID":asuID]
        
        //print(data)
        
         var url = "http://72.201.206.220:8000/getClassInfo/"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                print("SUCCESS")
                //print(response.result.value)
                do{
                    var json = try JSON(data: response.data!)
                    //print(json)
                    //print(json["message"])
                    let curLog = json["logs"].string
                    let jobs = json["jobs"].string
                    let mode = json["mode"].string
                    let count = json["count"].int
                    let courseID = json["courseID"].string
                    do
                    {
                        self.logs = try curLog
                        self.curJobID = jobs
                        self.currentMode = mode
                       
                        
                        if count != nil
                        {
                        self.currentCount = String(count!)
                        }
                        else
                        {
                            self.currentCount = "0"
                        }
                        self.currentID = courseID
                        self.logTableView.reloadData()
                    }
                    catch
                    {
                        throw error
                       self.logs = "Fail to retrieve log information!"
                    }
                   
                    
                    //print(response)
                  
                }
                catch{
                    print("invalid ")
                    
                }
            case .failure:
                print("ERROR")
                
                
            }
        }
        
        
        
        
      
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.isEqual(logTableView)
        {
            return 1
        }
        else
        {
        print(classID?.count)
        return classID?.count ?? 0
        }
        
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {//let cell  = tableView.dequeueReusableCell(withIdentifier: "courseDetailCell") as! courseDetailCell
        // let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier:)
        //let cell1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "courseCell") as! courseInfoCell
        if tableView.isEqual(logTableView)
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "logcell") as! logtableCellTableViewCell
            
             cell1.layer.masksToBounds = true
            cell1.layer.cornerRadius = 8
            cell1.textLabel?.font = UIFont(name: "", size: CGFloat(10))
            cell1.textLabel?.textColor = UIColor.darkGray
            cell1.detailTextLabel?.textColor = UIColor.darkGray
            cell1.textLabel?.backgroundColor = UIColor.clear
            cell1.detailTextLabel?.backgroundColor = UIColor.clear
            if self.curJobID != nil
            {
            cell1.jobID!.text = "Job ID: \(self.curJobID!)"
            }
            else
            {
                cell1.jobID!.text = "Job ID: Fail to fetch information"
            }
            if self.logs != nil
            {
            cell1.logs?.text = "Log: \(self.logs!)"
            }
            else
            {
                cell1.logs?.text = "Log: Fail to fetch information"
            }
            if self.currentMode != nil
            {
            cell1.mod?.text = "Mode: \(self.currentMode!)"
            }
            else
            {
                cell1.mod?.text = "Mode: Fail to fetch information"
            }
            if self.currentCount != nil
            {
            cell1.count?.text = "Count: \(self.currentCount!)"
            }
            else
            {
                 cell1.count?.text = "Count: Fail to fetch information"
            }
            
            
             if self.currentID != nil
             {
            cell1.targetCourse?.text = "Target Class: \(self.currentID!)"
            }
            else
             { cell1.targetCourse?.text = "Target Class: Fail to fetch information"
                
            }
            
            
            cell1.backgroundColor = UIColor.lightText
            
            return cell1
        }
        else
        {
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
                UIView.animate(withDuration: 0.5) {
                    var image : UIImage = UIImage(named: "closed_final3")!
                    
                    cell1.curStatus.image = image
                }
                
            }
            else{
                UIView.animate(withDuration: 0.5) {
                    var image : UIImage = UIImage(named: "open_final4")!
                    
                    cell1.curStatus.image = image
                }
               
            }
        }
        
        return cell1
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.isEqual(logTableView)
        {
            
            return "Logs"
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView.isEqual(logTableView)
        {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.clear
            headerView.textLabel?.textColor = UIColor.white
            headerView.textLabel?.font = UIFont(name: "test", size: CGFloat(20))
        }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.isEqual(logTableView)
        {
            
        }
        else
        {
            if isloading == false
            {
        if (editingStyle == .delete) {
            print("delete")
            
            var url = "http://72.201.206.220:6800/cancel.json"
            
            var data = ["project":"seatsfinder","job":self.jobidList![indexPath.row]]
            
            
            
            
            Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    print("SUCCESS")
                    print(response)
                    
                case .failure:
                    print("ERROR")
                    
                    
                }
            }
            print(indexPath.row)
            print(self.asuID)
            print(self.classID)
            deleteTaskFromFRbase(classID: self.classID![indexPath.row],user: self.asuID![indexPath.row])
            
            
            
            deleteData("Entity",self.classID![indexPath.row])
            self.termList?.remove(at: indexPath.row)
            self.classID?.remove(at: indexPath.row)
            self.className?.remove(at: indexPath.row)
            self.instructorlist?.remove(at: indexPath.row)
            self.courseStatusList?.remove(at: indexPath.row)
            
            
            
                
            monitorTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.monitorTable.reloadData()
            
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
            }
            else
            {}
        }
    }
    func deleteTaskFromFRbase(classID:String,user:String)
    {
        var url = "http://72.201.206.220:8000/delClass/"
        
        //var data = ["project":"seatsfinder","job":self.jobidList![indexPath.row]]
        
        var data:JSON = ["classId": classID,"user": user]
        
        print("firebase:\(data)")
        
        let parameters: [String: Any] = [
            
            "user2": [
                [
                    "classId" : classID,
                    "user": user,
                    
                ]
            ]]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("SUCCESS")
                print(response)
                
            case .failure:
                
                print(response)
                print("ERROR2")
                
                
            }
        }
    }
}
extension UserDefaults {
    //应用第一次启动
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    //当前版本第一次启动
    static func isFirstLaunchOfNewVersion() -> Bool {
        //主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String
        
        //上次启动的版本号
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedOfNewVersion"
        let lastLaunchVersion = UserDefaults.standard.string(forKey:
            hasBeenLaunchedOfNewVersion)
        
        //版本号比较
        let isFirstLaunchOfNewVersion = majorVersion != lastLaunchVersion
        if isFirstLaunchOfNewVersion {
            UserDefaults.standard.set(majorVersion, forKey:
                hasBeenLaunchedOfNewVersion)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunchOfNewVersion
    }
}
