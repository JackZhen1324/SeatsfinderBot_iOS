//
//  privacyViewController.swift
//  SeatsFinderBot
//
//  Created by ZhenQian on 5/20/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import UIKit
import WebKit
class privacyViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var privacyView: UIWebView!
     var activityIndicator:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let request = URLRequest(url: URL(string: "https://www.freeprivacypolicy.com/privacy/view/341d0799f02fbf541d1fe7933f023bd0")!)
        privacyView.loadRequest(request)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.isHidden = true
        activityIndicator?.style = .gray
        activityIndicator?.frame = CGRect(x: Double(0.0), y: Double(0.0), width: Double(50), height: Double(50))
        activityIndicator?.layer.position = self.view.center
        
        self.view.addSubview(activityIndicator!)
        // Do any additional setup after loading the view.
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start loding")
        activityIndicator?.startAnimating()
        activityIndicator?.isHidden = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator?.stopAnimating()
        activityIndicator?.isHidden = true
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
