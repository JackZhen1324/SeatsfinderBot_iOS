//
//  ContackViewController.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 11/21/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ContackViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textBox: UITextView!
    override func viewDidLoad() {
        textBox.delegate = self
       textBox.text = "     Lell us something about the App:-)"
        textBox.textColor = UIColor.lightGray
        super.viewDidLoad()
navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sentTapped))
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "       Lell us something about the App:-)"
            textView.textColor = UIColor.lightGray
        }
    }
    @objc func sentTapped() {
        var isCourseExist = self.sendResponse()
                     {
                             (success) in
                             print(success)
                             if success == true
                             
                             {
                                  let alert = UIAlertController(title: "Success!", message: "Thank you for your response!", preferredStyle: .alert)
                                  let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                           (_) in
                                       self.performSegue(withIdentifier: "Tosetting", sender: self)
                                   })
                                  
                                   alert.addAction(OKAction)
                                    self.present(alert, animated: true, completion: nil)
                                
                         }
                         else
                         {
                             let alert = UIAlertController(title: "Error!", message: "Fail to send the response, please check your network connection!", preferredStyle: .alert)
                             let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                      (_) in
                                  
                              })
                             
                              alert.addAction(OKAction)
                               self.present(alert, animated: true, completion: nil)
                         }
                     }
        
        
        
        
        
    }
    
    
    func sendResponse(completion:((_ success: Bool)->Void)?)
       {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        let url = "http://68.225.193.31:8000/sendReport/"
           let newToken = (UIApplication.shared.delegate as! AppDelegate).deviceID
           print(newToken)
        let data = ["content":String(textBox.text),"asuID":String(UserDefaults.standard.string(forKey: "asuID" ) ?? "zqian15" ),"deviceID":newToken]
           print(data)
           Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { response in
               do{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
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
                   completion?(false)
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
