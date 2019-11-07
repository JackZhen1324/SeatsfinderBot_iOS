//
//  overViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/12/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON
class overViewController: UITableViewController {
   
    
    @IBOutlet weak var submit_Progress_view: UIActivityIndicatorView!
    var className_:String?
    var classID_:String?
    var instructor_:String?
    let studetnID_ = UserDefaults.standard.string(forKey: "asuID")
    var term:String?
    let studentPas = UserDefaults.standard.string(forKey: "asuPass")
    @IBOutlet weak var asuIDInput: UITextField!
    @IBOutlet weak var asuPassInput: UITextField!
    /*
    @IBOutlet weak var instructorInfo: UILabel!
    
    @IBOutlet weak var semesterInfo: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classid: UILabel!
 
     
     
     */@IBOutlet weak var swapTo: UITextField!
    @IBOutlet weak var modeInput_: UISegmentedControl!
   
    @IBOutlet weak var submit_button: UIButton!
    @IBOutlet weak var asuIdCell: UITableViewCell!
    @IBOutlet weak var botMode: UITableViewCell!
    @IBOutlet weak var semesterInfo: UILabel!
    @IBOutlet weak var classid: UILabel!
    @IBOutlet weak var duoAuth: UISegmentedControl!
    
    @IBOutlet var overViewTable: UITableView!
    @IBOutlet weak var passwordCell: UITableViewCell!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var instructorInfo: UILabel!
    let data = ["Add", "Swap"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupButton()
        
        overViewTable.delegate = self
        overViewTable.dataSource = self
        
        
        
        self.navigationController?.navigationItem.title = "Overview"
        
        self.tableView.rowHeight = 44;
        instructorInfo.text = self.instructor_
        
        className.text = self.className_
        classid.text = self.classID_
        semesterInfo.text = term
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        
        if indexPath.section == 1 && indexPath.row == 0 {
           
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
   func setupButton()
   {
    let bezierPath = UIBezierPath(roundedRect: submit_button.bounds,
                                  byRoundingCorners: [.allCorners], //哪个角
        cornerRadii: CGSize(width: 5, height: 5)) //圆角半径
    let maskLayer = CAShapeLayer()
    maskLayer.path = bezierPath.cgPath
    submit_button.layer.mask = maskLayer;
    
    }
    
    
    func saveCourseInfo(courseID:String,courseName:String,courseTitle:String,Instructor:String,termInfo:String,time:String,status:String)
    {
        print("saveCourseInfo")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(courseID, forKey: "courseID")
        newUser.setValue(courseName, forKey: "courseName")
        newUser.setValue(Instructor, forKey: "instructorInfo")
        newUser.setValue(termInfo, forKey: "courseTerm")
        newUser.setValue(time, forKey: "coutseTime")
        newUser.setValue(status, forKey: "courseStatus")
        newUser.setValue(courseTitle, forKey: "courseTitle")
        do {
            try context.save()
            print("success")
        } catch {
            print("Failed saving")
        }
        
    }
    
    @IBAction func schedule_Button(_ sender: Any)
    {
        print("send request")
        self.submit_Progress_view.startAnimating()
        var twoSteps = "disable"
        if duoAuth.selectedSegmentIndex == 0
        {
            twoSteps = "enable"
        }
        else
        {
            twoSteps = "disable"
        }
        
        
        
        if modeInput_.selectedSegmentIndex == 0 {
            self.submit_button.setAttributedTitle(NSAttributedString(string: ""), for: .disabled)
            UIView.animate(withDuration: 1) {
                
                self.submit_button.isEnabled = false
                self.submit_button.backgroundColor = UIColor.gray
                
            }
            var password:String!
            var username:String!
            var level:String!
            var choice:String!
            var url:String! = "http://72.201.206.220:8000/addClass/"
            var project:String! = "seatsfinder"
            var spider:String! = "seatsfinderbots"
            var semester:String! = self.term?.replacingOccurrences(of: " ", with: "+")
            let index = self.classID_?.index((self.classID_?.startIndex)!, offsetBy: 4)
            var section:String! = self.className_
            let newToken = (UIApplication.shared.delegate as! AppDelegate).deviceID
            let courseID__:String = self.classID_ ?? "Unknown Course ID"
            let instructor__:String = self.instructor_ ?? "Unknown Instructor"
            if self.classID_![index!] == "5"
            {
                print("print from GRAD\(classID_)" )
             level = "GRAD"
            }
            else
            {
                print("print from UGRA\(classID_)" )
             level = "UGRA"
            }
            if modeInput_.selectedSegmentIndex == 0
            {
             choice = "add"
            }
            else
            {
                 choice = "swap"
            }
            var reserved:String! = "0"
            
            if (self.studetnID_ ?? "").isEmpty   || (self.studentPas ?? "").isEmpty
            {
                
                if asuIDInput.text!.isEmpty || asuPassInput.text!.isEmpty
                {
                    asuPassInput.shake()
                    asuIDInput.shake()
                }
                else
                {
                    username = self.asuIDInput.text!
                    password = self.asuPassInput.text!
                    print("we are here1")
                    SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                }
            }
            else
            {
                if asuIDInput.text!.isEmpty || asuPassInput.text!.isEmpty
                {print("we are here2")
                     username = self.studetnID_!
                    password = self.studentPas!
                    print(username,password)
                    SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                }
                else
                { print("we are here3")
                    username = self.asuIDInput.text!
                    password = self.asuPassInput.text!
                    SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                }
                
            }
           
            
           
            
            
            
        }
        else{
            
           
            
            if (swapTo.text ?? "").isEmpty {
            self.submit_button.setTitle("Schedule Now", for: .normal)
           /*
            UIView.animate(withDuration: 1, animations: {
                self.swapTo.layer.borderColor = UIColor.init(displayP3Red: CGFloat(252.0/255.0), green: CGFloat(72.0/255.0), blue: CGFloat(79.0/255.0), alpha: CGFloat(1)).cgColor
                self.swapTo.layer.cornerRadius = 5
                self.swapTo.layer.borderWidth = 1
                self.submit_button.isEnabled = true
                self.submit_button.backgroundColor = UIColor.init(displayP3Red: CGFloat(52.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1))
            }) { (Bool) in
                
                }
                 */
               self.submit_button.shake()
                self.swapTo.shake()
                self.submit_Progress_view.stopAnimating()
                
            }
            else
            {
                
                
                var password:String!
                var username:String!
                var level:String!
                var choice:String!
                
                var url:String! = "http://72.201.206.220:8000/addClass/"
                var project:String! = "seatsfinder"
                var spider:String! = "seatsfinderbots"
                var semester:String! = self.term?.replacingOccurrences(of: " ", with: "+")
                let index = self.classID_?.index((self.classID_?.startIndex)!, offsetBy: 4)
                var section:String! = self.className_
                let newToken = (UIApplication.shared.delegate as! AppDelegate).deviceID
                let courseID__:String = self.classID_ ?? "Unknown Course ID"
                let instructor__:String = self.instructor_ ?? "Unknown Instructor"
                
                if self.classID_![index!] == "5"
                {
                    print("print from GRAD\(classID_)" )
                    level = "GRAD"
                }
                else
                {
                    print("print from UGRA\(classID_)" )
                    level = "UGRA"
                }
                if modeInput_.selectedSegmentIndex == 0
                {
                    choice = "add"
                }
                else
                {
                    choice = "swap"
                }
                var reserved:String! = "0"
                
                if (self.studetnID_ ?? "").isEmpty   || (self.studentPas ?? "").isEmpty
                {
                    
                    if asuIDInput.text!.isEmpty || asuPassInput.text!.isEmpty
                    {
                        asuPassInput.shake()
                        asuIDInput.shake()
                    }
                    else
                    {
                        username = self.asuIDInput.text!
                        password = self.asuPassInput.text!
                        print("we are here1")
                        SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                    }
                }
                else
                {
                    if asuIDInput.text!.isEmpty || asuPassInput.text!.isEmpty
                    {print("we are here2")
                        username = self.studetnID_!
                        password = self.studentPas!
                        print(username,password)
                        SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                    }
                    else
                    { print("we are here3")
                        username = self.asuIDInput.text!
                        password = self.asuPassInput.text!
                        SendSchdeuleRequest(url: url, project: project, spider: spider, semester: semester, section: section, level: level, choice: choice, reserved: reserved, username: username, password: password, timeinterval: "2", deviceId: newToken,swapWith: self.swapTo.text ?? "",courseID:courseID__,instructor:instructor__,twoSteps: twoSteps)
                    }
                    
                }
                
                
                
            }
                
            
            
            
            
        }
    }
    
    func SendSchdeuleRequest(url:String?,project:String?,spider:String?,semester:String?,section:String?,level:String?,choice:String?,reserved:String?,username:String?,password:String?,timeinterval:String?,deviceId:String?,swapWith:String = "",courseID:String,instructor:String,twoSteps:String){
        var timeInterval:String! = "2"
        let newToken = (UIApplication.shared.delegate as! AppDelegate).deviceID
        let data = ["project":project!,"spider":spider!,"semester":semester! ,"section":section!,"level":level!,"choice":choice!,"reserved":reserved!,"username":username!,"password":password!,"timeInterval":timeInterval!,"deviceID":newToken,"swapWith":swapWith,"courseID":courseID,"instructor":instructor,"twoSteps":twoSteps]
        
        print("请求表\(data)")
        
        var isCourseExist = checkCourseExist(asuID: username!, classID: section!)
        {
            (success) in
            print(success)
            if success == true
            
            {
                Alamofire.request(url!, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success:
                        print("SUCCESS")
                        var asuID = ""
                        //print(response.result.value)
                        if let stringCount = self.studetnID_?.characters.count, stringCount > 0 {
                            asuID = self.studetnID_!
                            //print("字符串不为nil，长度大于0")
                        }
                        else{
                            asuID = self.asuIDInput.text!
                            //print("可能字符串为nil,或者字符串不为nil但是长度为0")
                        }
                        do{
                            var json = try JSON(data: response.data!)
                            print(json)
                            print(self.className,self.classID_,self.instructor_,self.term,json["jobid"].string)
                            self.saveCourseInfo(courseID: self.className_!, courseName: self.classID_!, courseTitle:asuID , Instructor: self.instructor_!, termInfo: self.term!, time: json["jobid"].string!, status: "close")
                            
                            self.performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
                        }
                        catch{
                            print("fail to get jobid")
                        }
                    case .failure:
                        print("ERROR")
                        
                        
                    }
                }
        }
        else
        {
            let alert = UIAlertController(title: "Oops", message: "Course Exist!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            UIView.animate(withDuration: 1, animations: {
                self.submit_button.backgroundColor = UIColor.init(displayP3Red: CGFloat(66.0/255.0), green: CGFloat(36.0/255.0), blue: CGFloat(9.0/255.0), alpha: CGFloat(1.0))
                self.submit_button.isEnabled = true
                self.submit_Progress_view.stopAnimating()
            })
            print("course exist!")
        }
    }
    }
    func checkCourseExist(asuID:String,classID:String,completion:((_ success: Bool)->Void)?)
    { let url = "http://72.201.206.220:8000/checkCourseExist/"
        let data = ["asuID":asuID,"courseID":classID]
        var isExist = ""
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default).responseJSON { response in
            do{
                var json = try JSON(data: response.data!)
                if(json["result"]=="success"){
                    isExist = "1"
                    completion?(true)
                }
                else
                {
                    isExist = "0"
                    completion?(false)
                }
                
                
            }
            catch
            {
                completion?(true)
                print("error")
            }
            
        }
        
    }
    @IBAction func modeInputEvent(_ sender: Any) {
        if modeInput_.selectedSegmentIndex == 0 {
            swapTo.placeholder="Optional"
            self.swapTo.layer.borderColor = UIColor.gray.cgColor
            self.swapTo.layer.borderWidth = 0
            
        }
        else
        {
            swapTo.placeholder = "#87660"
        }
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


