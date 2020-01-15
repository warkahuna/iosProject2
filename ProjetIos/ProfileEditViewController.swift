//
//  ProfileEditViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 1/13/20.
//  Copyright © 2020 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class ProfileEditViewController: UIViewController {
    
    var users:NSArray = []
    var userVerification:Dictionary<String,Any> = [:]
    var user:Dictionary<String,Any> = [:]
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser(userName: UserDefaults.standard.string(forKey: "user")!)
        // Do any additional setup after loading the view.
    }
    
    //editig did end
    @IBAction func doneFNameUpdate(_ sender: Any) {
    updateProfile()
    }
    
    @IBAction func doneLNameUpdate(_ sender: Any) {
    updateProfile()
    }
    
    @IBAction func donePhoneUpdate(_ sender: Any) {
    updateProfile()
    }
    
    @IBAction func doneAddressUpdate(_ sender: Any) {
    updateProfile()
    }
    
    func updateProfile()
    {
        let param = ["username" : email.text!,"firstname":fName.text!,"lastname":lName.text!,"telenumber":phone.text!,"address":Address.text!]
        
        Alamofire.request( Server.ip+"api/Dataupadte",method: .put, parameters: param,encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
            
            /*let alert = UIAlertController(title: "profile update", message: "profile update complete", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true,completion: nil)*/
        }
    }
    func getUser(userName:String)
    {
        
        Alamofire.request( Server.ip+"api/getUser",method: .post, parameters:["username" : userName],encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
            if let arrayVersion = response.result.value as? NSArray
            {
                self.users = response.result.value as! NSArray
                self.user = self.users[0] as! Dictionary<String,Any>
                self.fName.text = self.user["firstname"] as! String
                self.lName.text = self.user["lastname"] as! String
                self.Address.text = self.user["address"] as! String
                self.phone.text = self.user["tele_num"] as! String
                self.email.text = self.user["username"] as! String
            }
            else if let dictionaryVersion = response.result.value as? NSDictionary
            {
                self.userVerification = response.result.value as! Dictionary<String,Any>
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
