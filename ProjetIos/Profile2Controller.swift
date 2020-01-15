//
//  Profile2Controller.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/27/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import DateToolsSwift

class Profile2Controller: UIViewController,UITableViewDataSource,UITableViewDelegate{
   
    
    var users:NSArray = []
    var userVerification:Dictionary<String,Any> = [:]
    var user:Dictionary<String,Any> = [:]
    var myParts:NSArray = []
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var flName: UILabel!
    @IBOutlet weak var datee: UILabel!
    @IBOutlet weak var partsTab: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.layer.cornerRadius = logo.frame.width/2

        if UserDefaults.standard.string(forKey: "user") != nil && UserDefaults.standard.string(forKey: "user") != ""
        {
        getUser(userName: UserDefaults.standard.string(forKey: "user")!)
        fetchMyParts()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Parts")
        let contentView = cell?.viewWithTag(0)
        
        let partsName = contentView?.viewWithTag(2) as! UILabel
        let category = contentView?.viewWithTag(3) as! UILabel
        let image = contentView?.viewWithTag(1) as! UIImageView
       
        let result = myParts[indexPath.row] as! Dictionary<String,Any>
        partsName.text = result["name"] as! String
        category.text =  result["Type"] as! String
        
       /* let dataDecoded : Data = Data(base64Encoded: result["String_image"] as! String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        image.image = decodedimage*/
        
        return cell!
    }
    
    
    
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    @IBAction func myParts(_ sender: Any) {
        performSegue(withIdentifier: "myPartsList", sender: self)
    }
    
    func getUser(userName:String)
    {
        
        Alamofire.request( Server.ip+"api/getUser",method: .post, parameters:["username" : userName],encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
            if let arrayVersion = response.result.value as? NSArray
            {
                self.users = response.result.value as! NSArray
                self.user = self.users[0] as! Dictionary<String,Any>
                self.flName.text = (self.user["firstname"] as! String)+" "+(self.user["lastname"] as! String)
                
                self.datee.text = self.timeAgo(date: self.user["created"] as! String)
                
                let logos = self.user["lastname"] as! String
                self.logo.text = String(logos[logos.startIndex]).uppercased()
                
            }
            else if let dictionaryVersion = response.result.value as? NSDictionary
            {
                self.userVerification = response.result.value as! Dictionary<String,Any>
            }
        }
    }
    func timeAgo(date:String) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: date)
        return date!.timeAgoSinceNow
    }
    
    func fetchMyParts(){
            Alamofire.request( Server.ip+"api/parts/getPartsIduser",method: .post, parameters:["username" : UserDefaults.standard.string(forKey: "user")],encoding: JSONEncoding.default ) .responseJSON{ response in
                
                //print(response)
                if let arrayVersion = response.result.value as? NSArray
                {
            self.myParts = response.result.value as! NSArray
                }
            self.partsTab.reloadData()
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
