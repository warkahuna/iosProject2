//
//  ContactViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 12/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
class ContactViewController: UIViewController {
    
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var partName: UILabel!
    @IBOutlet weak var partPrice: UILabel!
    
    var info:Dictionary<String,Any> = [:]
    var user:Dictionary<String,Any> = [:]
    var userInfo:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        
        owner.text = "Contacting : "+(info["owner"] as! String)
        partName.text = "Regarding the Deal named : "+( info["name"] as! String)
        partPrice.text = "Suggested Price by the onwer is : "+( String(info["Price"] as! Double)+" TND")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func phoneCall(_ sender: Any) {
        guard let number = URL(string: "tel://" + (user["tele_num"] as! String)) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func mail(_ sender: Any) {
        let email = user["username"] as! String
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func liveChat(_ sender: Any) {
    }
    
    func getUser()
    {
        
        Alamofire.request( Server.ip+"api/getUser",method: .post, parameters:["username" : info["owner"] as! String],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            self.userInfo = response.result.value as! NSArray
            
            self.user = self.userInfo.firstObject as! Dictionary<String,Any>
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backtToSalesDetailViewController"
        {
            let backtToSalesDetailViewController = segue.destination as! SaleDetailsViewController
            
            backtToSalesDetailViewController.result = info
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
