//
//  registerViewcontrollerViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/19/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class registerViewcontrollerViewController: UIViewController {
    @IBOutlet weak var isloading: UIActivityIndicatorView!
    
    @IBOutlet weak var asuPass: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var asuID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10
        asuPass.layer.cornerRadius = 10
        asuID.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.isToolbarHidden = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }

    @IBAction func registerFunction(_ sender: Any) {
        isloading.startAnimating()
        isloading.isHidden = false
        if asuID.text!.isEmpty || asuPass.text!.isEmpty
        {
            isloading.stopAnimating()
            asuID.shake()
            asuPass.shake()
            
            print("empty")
        }
        else
        {
             UserDefaults.standard.set(String(asuID.text!), forKey: "asuID")
             UserDefaults.standard.set(String(asuPass.text!), forKey: "asuPass")
            self.registerButton.isEnabled = false
            self.registerButton.setAttributedTitle(NSAttributedString(string: ""), for: .disabled)
            
            
            UIView.animate(withDuration: 1, animations: {
                
                self.registerButton.backgroundColor = UIColor.gray
            }) { (Bool) in
                
                var isCourseExist = self.registerUser()
                {
                        (success) in
                        print(success)
                        if success == true
                        
                        {
                             self.performSegue(withIdentifier: "fromRegister", sender: Any?.self)
                           
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "fromRegister", sender: Any?.self)
                    }
                }
                
                
            }
            
        }
        
        
      
    }
    func registerUser(completion:((_ success: Bool)->Void)?)
    { let url = "http://68.225.193.31:8000/registerUser/"
        let newToken = (UIApplication.shared.delegate as! AppDelegate).deviceID
        print(newToken)
        let data = ["userID":newToken,"asuID":String(asuID.text!)]
        print(data)
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { response in
            do{
                var json = try JSON(data: response.data!)
                if(json["result"]=="success"){
                    
                    completion?(true)
                }
                else
                {
                    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
