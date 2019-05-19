//
//  rootViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/16/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit

class rootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstViewController = mainSplitViewViewController()
        
        
        firstViewController.tabBarItem = UITabBarItem(title: "Monitoring", image: UIImage(named: "test"), tag: 0)
        
        let secondViewController = setingPageController()
        
        secondViewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "test2"), tag: 1)
        
        let tabBarList = [firstViewController, secondViewController]
        
        viewControllers = tabBarList
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
