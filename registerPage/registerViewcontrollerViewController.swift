//
//  registerViewcontrollerViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/19/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

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
            UIView.animate(withDuration: 1, animations: {
                self.registerButton.setTitle("", for: UIControl.State.disabled)
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = UIColor.gray
            }) { (Bool) in
                 self.performSegue(withIdentifier: "fromRegister", sender: Any?.self)
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
