//
//  AboutCFViewController.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 11/21/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class AboutCFViewController: UIViewController {

    @IBOutlet weak var CFLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CFLogo.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     @IBAction func backToSetting(segue:UIStoryboardSegue) { }
    

}
