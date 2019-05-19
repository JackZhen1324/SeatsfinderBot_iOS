//
//  LogViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/16/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    @IBOutlet weak var logviewTable: UITableView!
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.frame.size.height = 900
        print(self.view.bounds.height)
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
