//
//  setingPageController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/9/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import UserNotifications
class setingPageController: UITableViewController {
    @IBOutlet weak var asuID: UILabel!
   
    let urlObj = URL(string:UIApplication.openSettingsURLString)
    @IBOutlet weak var switchNoti: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let curID = UserDefaults.standard.string(forKey: "asuID") ?? "Unkown ID"
        let curPass = UserDefaults.standard.string(forKey: "asuPass") ?? " Unkonw Password"
       asuID.text = curID
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(initNotifications), name: NSNotification.Name(rawValue:"isTest"), object: nil)

        print("helo")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("返回")
        let curID = UserDefaults.standard.string(forKey: "asuID") ?? "Unkown ID"
        let curPass = UserDefaults.standard.string(forKey: "asuPass") ?? " Unkonwn Password"
        asuID.text = curID
       
        //   navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "mine_settingIcon2", highlightedImage: "mine_settingIcon2_press", target: self, action: #selector(MeVC.settingClick))
        // 设置弹出提示框的底层视图控制器 代码初始化放在这 返回的时候才可改变通知
        initNotifications()
    }
    // 通告 权限
    @objc func initNotifications() {
        print("hellp")
        let notiSetting = UIApplication.shared.currentUserNotificationSettings
        if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
            self.switchNoti.isOn = false
        } else {
            self.switchNoti.isOn = true
            self.switchNoti.isEnabled = true
        }
        
    }
    @IBAction func swtichNotiTap(_ sender: Any) {
        
        // 前往设置
        UIApplication.shared.open(urlObj! as URL, options: [ : ]) { (result) in
            // 如果判断是否返回成功
            if result {
                
                let notiSetting = UIApplication.shared.currentUserNotificationSettings
                if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
                    self.switchNoti.isOn = false
                    self.switchNoti.isEnabled = true
                } else {
                    self.switchNoti.isOn = true
                    self.switchNoti.isEnabled = true
                }
                
                
            }
        }
    }
   
    
@IBAction func unwindTosetting(segue:UIStoryboardSegue) { }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension setingPageController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 0
        {
            self.performSegue(withIdentifier: "toChangeAccount", sender: Any?.self)
        }
        if indexPath.section == 2
        {
            if indexPath.row == 0{
            self.performSegue(withIdentifier: "aboutSF", sender: Any?.self)
            }
            else{
                self.performSegue(withIdentifier: "privacy", sender: Any?.self)
            }
        }
        
    }
}
