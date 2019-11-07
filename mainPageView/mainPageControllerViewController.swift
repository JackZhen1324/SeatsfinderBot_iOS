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
    let nslock = NSLock()
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
    {
       
        didSet
        {
            if self.classID?.isEmpty == true
            {
                self.announcementTitle.isHidden = false
                self.announcementContent.isHidden = false
                
            }
            else
            {
                self.announcementTitle.isHidden = true
                self.announcementContent.isHidden = true
            }
            
        }
    }
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
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.beginRefreshing()
      
        isloading = true
        print("viewWillAppear232323")
        
        reloadData()
            {
                (success) in
                if success == true
                {
                    
                }
                else
                {
                    
                }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCurrentUser()
        
        print("是否第一次运行？\(UserDefaults.isFirstLaunch() )")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.termList = []
        self.classID = []
        self.className = []
        self.instructorlist = []
        self.courseStatusList = []
        self.asuID = []
        self.jobidList = []
        if(UserDefaults.isFirstLaunch()==true)
        {
            performSegue(withIdentifier: "goRgister", sender: Any?.self)
        }
        showCurrentUser()
        self.hideView.isHidden  = true
        
        self.isChecking = "1"
        
        logTableView.layer.cornerRadius = 10
        logTableView.layer.backgroundColor = UIColor.lightGray.cgColor
        //logTableView.layoutIfNeeded()
        //logTableView.rowHeight = logTableView.contentSize.height
        //logTableView.rowHeight = CGFloat(integerLiteral: 150)
        
        setupTableView()
        
        extendedLayoutIncludesOpaqueBars = true
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Refreshing..")
        //refreshControl.layoutIfNeeded()
        //refreshControl.beginRefreshing()
        //refreshPulled()
        getCurrentTerm()
        self.announcementContent.isHidden = false
        self.announcementTitle.isHidden = false
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
        
            self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        self.refreshControl.beginRefreshing()
       
            self.reloadData{
            (success) in
            if success == true
            {
                self.refreshControl.endRefreshing()
            }
            else
            {
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    func showCurrentUser()  {
        let currentUSER = UserDefaults.standard.string(forKey: "asuID") ?? "Unknown"
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
    }
    @objc func refreshPulled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [refreshControl] in
            refreshControl.endRefreshing()
            //let top = self.monitorTable.adjustedContentInset.top
            //let y = self.refreshControl.frame.maxY + top
            //self.monitorTable.setContentOffset(CGPoint(x: 0, y: -y), animated:true)
            self.refreshControl.endRefreshing()
            
        }
    }
    private func fetchWeatherData() {
        //self.refreshControl.beginRefreshing()
            DispatchQueue.main.async {
                self.isloading = true
                
                self.reloadData{
                    (success) in
                    if success == true
                    {
                        self.refreshControl.endRefreshing()
                    }
                    else
                    {
                         self.refreshControl.endRefreshing()
                    }
                }
                //self.refreshControl.endRefreshing()
                self.refreshPulled()
                
                
                
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
        addButton.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2.0
 
    }
    
    func reloadData(completion:((_ success: Bool)->Void)?)
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
            getAllCourseInfo(asuID: currentUSER)
            
            
        } catch {
            
            print("Failed")
        }
        monitorTable.reloadData()
        
        
        
        
    }
    func getAllCourseInfo(asuID:String) {
        var data = ["asuID":asuID]
        
        //print(data)
        
        var url = "http://72.201.206.220:8000/fetchAllCourse/"
        
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
                        self.monitorTable.reloadData()
                        //self.updateCourseStatus(courseName: subJson["section"].string ?? "N/A",term: subJson["semester"].string ?? "UnknownTerm",index1: i)
                        i = i + 1
                        
                    }
                   
                    
                    self.refreshControl.endRefreshing()
                    self.isloading = false
                    
                    
                    
                }
                catch{
                    print("invalid ")
                    self.refreshControl.endRefreshing()
                    self.isloading = false
                    
                }
            case .failure:
                self.refreshControl.endRefreshing()
                self.isloading = false
                print("ERROR")
                
                
            }
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

extension mainPageControllerViewController:UITableViewDataSource,UITableViewDelegate
{
    @objc public func pressed(sender:Any)
    {
        self.isChecking = "0"
        self.lock = 1
        stopTheDamnRequests()
        UIView.animate(withDuration: 0.6) {
            self.logTableView.layer.position = CGPoint(x: self.logTableView.frame.width/2, y: self.view.frame.origin.y+self.view.frame.height*1.2)
            self.hideView.backgroundColor = UIColor.init(displayP3Red: CGFloat(239.0/255.0), green: CGFloat(239.0/255.0), blue: CGFloat(244.0/255.0), alpha: CGFloat(1))
            
        }
        self.hideView.isHidden = true
        
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEqual(logTableView)
        {
        let height = CGFloat(50.1)
        return height
        }
        else
        {
            return CGFloat(0.0)
        }
    }
     public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
          
        let frame: CGRect = tableView.frame
        
        let headerView: UIView = UIView(frame: CGRect(x:0,y: 0,width: frame.size.height,height:frame.size.width))
        
        let height = CGFloat(headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
        let headerTitle:UILabel = UILabel(frame: CGRect(x: self.view.bounds.width*0.06, y: headerView.frame.height*0.01, width: 150, height: height))
        let DoneBut: UIButton = UIButton(frame: CGRect(x: self.view.bounds.width*0.03, y: headerView.frame.height*0.03, width: 35, height: 35))
        
        headerTitle.text = "LOGS"
        headerTitle.textColor = UIColor.white
        headerTitle.font = UIFont(name: "System", size: CGFloat(14))
        let closeImg:UIImage = UIImage(named: "icons8-multiply-100")!
        
        DoneBut.setImage(closeImg, for: .normal)
        DoneBut.layoutIfNeeded()
        
        //DoneBut.setTitle("x", for: .normal)
        DoneBut.backgroundColor = UIColor.clear
        
        DoneBut.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        headerView.addSubview(DoneBut)
       //headerView.addSubview(headerTitle)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        //headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return headerView
 
        
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if tableView.isEqual(logTableView)
        {
            return ""
        }
        else
        {
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.isEqual(logTableView)
        {
            return CGFloat(50.0)
        }
        else{
            return CGFloat(0.0)
        }
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
           currentSelect = indexPath.row
       self.isChecking = "1"
            //print("current:  \(isChecking)")
            //print("lock:  \(self.lock)")
        if self.lock == 1
        {
            self.hideView.isHidden = false
            UIView.animate(withDuration: 0.6) {
                self.hideView.backgroundColor = UIColor.init(displayP3Red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5))
            }
        UIView.animate(withDuration: 0.6) {
            
            //self.logTableView.frame.size.width = self.view.frame.width
            self.logTableView.layer.position = CGPoint(x: self.logTableView.frame.width/2, y: self.view.frame.origin.y+self.view.frame.height/2)
            
            
        }
           
            DispatchQueue.global(qos: .background).async {
               // print("ischcek:\(self.isChecking)")
                
                while self.isChecking == "1"
                {   //print(self.asuID)
                    //print(self.classID)
                    //print(self.classID)
                    print(self.isChecking)
                    print(self.classID![indexPath.row])
                    do
                    {
                    try self.checkLogs(asuID: self.asuID![indexPath.row], courseID: self.classID![indexPath.row],index: indexPath.row)
                    sleep(1)
                    }
                    catch
                    {
                        print("check log fail")
                    }
                    
                }
               
                
                
                
                
            }
            
            self.lock = self.lock * -1
            
            
            }
            else
        {
            print("fail to retrive lock")
            }
            
        //print(self.logTableView.frame.height)
        }
        
        
    }
    func stopTheDamnRequests(){
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
    func checkLogs(asuID:String,courseID:String,index:Int)
    {
        
        var data = ["courseID":courseID,"asuID":asuID]
        
        //print(data)
        
         var url = "http://72.201.206.220:8000/getClassInfo/"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                //print("SUCCESS15")
                //print(response.result.value)
                do{
                    var json = try JSON(data: response.data!)
                    //print(json)
                    //print(json["message"])
                    self.curLo[index] = json["logs"].string ?? "none"
                    self.jobs[index] = json["jobs"].string ?? "none"
                    self.mode[index] = json["mode"].string ?? "none"
                    self.count[index] = json["count"].int ?? 0
                    self.courseID[index] = json["courseID"].string ?? "none"
                  
                    
                    //print(response)
                    self.logTableView.reloadData()
                  
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
        //print(classID?.count)
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
   
            print(jobs)
            if self.curJobID != nil
            {
            cell1.jobID!.text = "Job ID: \(self.jobs[currentSelect])"
            }
            else
            {
                cell1.jobID!.text = "Job ID: Fail to fetch information"
            }
            if self.logs != nil
            {
            cell1.logs?.text = "Log: \(self.curLo[currentSelect])"
            }
            else
            {
                cell1.logs?.text = "Log: Fail to fetch information"
            }
            if self.currentMode != nil
            {
            cell1.mod?.text = "Mode: \(self.mode[currentSelect])"
            }
            else
            {
                cell1.mod?.text = "Mode: Fail to fetch information"
            }
            if self.currentCount != nil
            {
            cell1.count?.text = "Count: \(self.count[currentSelect])"
            }
            else
            {
                 cell1.count?.text = "Count: Fail to fetch information"
            }
            
            
             if self.currentID != nil
             {
            cell1.targetCourse?.text = "Target Class: \(self.courseID[currentSelect])"
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
            //cell1.accessoryType = .disclosureIndicator
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
                    
                    var image : UIImage = UIImage(named: "open_5")!
                    cell1.curStatus.image = image
                }
                
            }
            else{
                UIView.animate(withDuration: 0.5) {
                    var image : UIImage = UIImage(named: "closed_5")!
                    
                    
                    cell1.curStatus.image = image
                }
               
            }
        }
        
        return cell1
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }/*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.isEqual(logTableView)
        {
            
            return "Logs"
        }
        else
        {
            return nil
        }
    }*/
    
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
                    print("SUCCESS2")
                    
                    //self.deleteTaskFromFRbase(classID: self.classID![indexPath.row],user: self.asuID![indexPath.row])
                    
                case .failure:
                    print("ERROR")
                    
                    
                }
            }
            print(indexPath.row)
            print("start deletihng")
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
        
        var data = ["classId": classID,"user": user]
        
        print("firebase:\(data)")
        
        let parameters: [String: Any] = [
            
            "user2": [
                [
                    "classId" : classID,
                    "user": user,
                    
                ]
            ]]
        
        print(parameters)
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("SUCCESS3")
                
                do{
                    var json = try JSON(data: response.data!)
                    print(json)
                    print("ERROR3")
                }
                catch
                {
                    
                }
                
            case .failure:
                do{
                    var json = try JSON(data: response.data!)
                    print(json)
                    print("ERROR2")
                }
                catch
                {
                    
                }
                
                
                
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
extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

