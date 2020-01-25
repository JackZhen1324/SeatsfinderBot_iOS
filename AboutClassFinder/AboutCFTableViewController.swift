//
//  AboutCFTableViewController.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 11/21/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class AboutCFTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            print("hello")
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

extension AboutCFTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 0
        { if indexPath.row == 0{
             var url  = NSURL(string: "https://apps.apple.com/us/app/classfinder-pro/id1464301208")

                           if UIApplication.shared.canOpenURL(url! as URL) {
                               UIApplication.shared.openURL(url! as URL)
                             
                         }
            }
        
        }
        
        
        
    }
}

