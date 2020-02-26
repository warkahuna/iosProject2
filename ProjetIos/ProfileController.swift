//
//  ProfileController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import FacebookLogin
import FacebookCore

class ProfileController: UIViewController {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var LogInVerificationMessage: UILabel!
    @IBOutlet weak var loginText: UILabel!
    
    var user:NSArray = []
    var userVerification:Dictionary<String,Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let imageView = UIImageView()
        //let image = UIImage(named: "mail")
        //imageView.image = image
        let loginButton = FBLoginButton(permissions: [ .publicProfile,.email ])
        loginButton.center = view.center
        
        //view.addSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        //everything works print the user data
                        //                        print(result!)
                        if let data = result as? NSDictionary
                        {
                            let firstName  = data.object(forKey: "first_name") as? String
                            let lastName  = data.object(forKey: "last_name") as? String
                            
                            if let email = data.object(forKey: "email") as? String
                            {
                                UserDefaults.standard.set(email, forKey: "user")
                                print(email)
                            }
                            else
                            {
                                // If user have signup with mobile number you are not able to get their email address
                                print("We are unable to access Facebook account details, please use other sign in methods.")
                            }
                        }
                    }
            })
        }
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let image = UIImage(named: "mail")
        imageView.image = image
        mail.leftView = imageView
        mail.leftViewMode = .always
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let image2 = UIImage(named: "password")
        imageView2.image = image2
        password.leftView = imageView2
        password.leftViewMode = .always
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishedEdit(_ sender: Any) {
        //getUser(userName: mail.text!)
    }
    @IBAction func signIn(_ sender: Any) {
        
       //mail.endEditing(true)
        
        
        if mail.text != "" && password.text != ""
        { 
            userLogin(userName: mail.text! , password: password.text!)
            //print(self.userVerification)
            
        }
        
    }
    
    func getUser(userName:String)
    {
        
        Alamofire.request( Server.ip+"api/getUser",method: .post, parameters:["username" : userName],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            self.user = response.result.value as! NSArray
           
        }
    }
    
    func userLogin(userName:String,password:String)
    {
        let param = ["username" : userName , "password" : password]
        
        Alamofire.request( Server.ip+"api/login",method: .post, parameters:param ,encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
            
            if let arrayVersion = response.result.value as? NSArray
            {
               self.user = response.result.value as! NSArray
            }
            else if let dictionaryVersion = response.result.value as? NSDictionary
            {
                self.userVerification = response.result.value as! Dictionary<String,Any>
                print(self.userVerification)
                if self.userVerification["message"] != nil
                {
                    if self.userVerification["message"] as! String == "JSON Data received successfully"
                    {
                        UserDefaults.standard.set(self.mail.text!, forKey: "user")
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "toMyProfile", sender: self)
                    }
                }
                else if self.userVerification["success"] != nil
                {
                    if self.userVerification["success"] as! String == "Username does not exits"
                    {
                        print("user not exist")
                        self.LogInVerificationMessage.text = "mail does not exist"
                        self.LogInVerificationMessage.isHidden = false
                        self.loginText.textColor = UIColor.red
                    }
                    else if self.userVerification["success"] as! String == "Username and password does not match"
                    {
                        print("password false")
                        self.LogInVerificationMessage.text = "wrong password/email"
                        self.LogInVerificationMessage.isHidden = false
                        self.loginText.textColor = UIColor.red

                    }
                }
                else
                {
                    self.LogInVerificationMessage.text = "no connection available"
                    self.LogInVerificationMessage.isHidden = false
                    self.loginText.textColor = UIColor.red

                }
            }
            
            
        }
        
        
        func saveUser()
        {
            let result = user[0] as! Dictionary<String,Any>

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let persistentContainer = appDelegate.persistentContainer
            
            let managedContext = persistentContainer.viewContext
            
            let UserEntityDescription = NSEntityDescription.entity(forEntityName: "LogedUser", in: managedContext)
            
            let users = NSManagedObject(entity: UserEntityDescription!, insertInto: managedContext)
            
            users.setValue(result["username"] as! String, forKey: "username")
            users.setValue(result["password"] as! String, forKey: "password")
            do{
                
                try  managedContext.save()
                
                let alert = UIAlertController(title: "welcome", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                
                alert.addAction(action)
                
                present(alert,animated: true,completion: nil)
                
                
            }catch let error as NSError{
                
                print(error.userInfo)
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
