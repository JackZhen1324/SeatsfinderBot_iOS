//
//  privacyViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/20/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import WebKit
class privacyViewController: UIViewController {

    @IBOutlet weak var privacyView: UIWebView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
       let request = URLRequest(url: URL(string: "https://www.freeprivacypolicy.com/privacy/view/341d0799f02fbf541d1fe7933f023bd0")!)
        privacyView.loadRequest(request)
        
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

}
