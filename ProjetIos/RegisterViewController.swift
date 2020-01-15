//
//  RegisterViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 1/12/20.
//  Copyright © 2020 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var required: UILabel!
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var fNameWarning: UILabel!
    
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var lNameWarning: UILabel!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var phoneWarning: UILabel!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailWarning: UILabel!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordWarning: UILabel!
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var confirmPasswordWarning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lNameWarning.isHidden = true
        fNameWarning.isHidden = true
        phoneWarning.isHidden = true
        emailWarning.isHidden = true
        passwordWarning.isHidden = true
        confirmPasswordWarning.isHidden = true
    }
    
    @IBAction func registerNow(_ sender: Any) {
       if check()
       {
        register()
       }
    }
    
    //edit did start
    @IBAction func fNameRemoveWarning(_ sender: Any) {
        fNameWarning.isHidden = true
    }
    @IBAction func LNameRemoveWarning(_ sender: Any) {
        lNameWarning.isHidden = true
    }
    @IBAction func phoneRemoveWarning(_ sender: Any) {
        phoneWarning.isHidden = true
    }
    @IBAction func emailRemoveWarning(_ sender: Any) {
        emailWarning.isHidden = true
    }
    @IBAction func passwordRemoveWarning(_ sender: Any) {
        passwordWarning.isHidden = true
    }
    
    func register()
    {
        
        let param = ["username" : email.text!,"password": password.text!,"firstname":fName.text!,"lastname":lName.text!,"address":address.text!,"mobile":phone.text!]
        Alamofire.request( Server.ip+"api/register",method: .post, parameters:param , encoding: JSONEncoding.default ) .responseString{ response in
            print(response)
            
            let alert = UIAlertController(title: "regsitration complete", message: "welcome among us", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func check()-> Bool
    {
        var checking:Bool = true
        let myColor = UIColor.red
        
        if lName.text == "" || fName.text == "" || phone.text == "" || email.text == "" || password.text == ""
        {
            checking = false
            required.textColor = myColor
        }
        if lName.text == ""
        {
            lNameWarning.isHidden = false
            lName.layer.borderColor = myColor.cgColor
            lName.layer.borderWidth = 1.0
            
        }
        
        if fName.text == ""
        {
            fNameWarning.isHidden = false
            fName.layer.borderColor = myColor.cgColor
            fName.layer.borderWidth = 1.0
        }
        
        if phone.text == ""
        {
            phoneWarning.isHidden = false
            phone.layer.borderColor = myColor.cgColor
            phone.layer.borderWidth = 1.0
        }
        
        if email.text == ""
        {
            emailWarning.isHidden = false
            email.layer.borderColor = myColor.cgColor
            email.layer.borderWidth = 1.0
        }
        else if email.text!.contains("@") == false && email.text!.contains(".") == false
        {
            emailWarning.text = "please provide a verified email address"
            checking = false
        }
        
        if password.text == ""
        {
            passwordWarning.isHidden = false
            password.layer.borderColor = myColor.cgColor
            password.layer.borderWidth = 1.0
        }
        
        if confirmPassword.text == ""
        {
            confirmPasswordWarning.isHidden = false
            confirmPassword.layer.borderColor = myColor.cgColor
            confirmPassword.layer.borderWidth = 1.0
        }
        
        if password.text != confirmPassword.text
        {
            confirmPasswordWarning.isHidden = false
            checking = false
        }
        
        
        return checking
    }
    

}
