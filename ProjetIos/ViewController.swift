//
//  ViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var profile2: UIView!
    @IBOutlet weak var home: UIView!
    @IBOutlet weak var favorite: UIView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var myCart: UIView!
    
    var x:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //checklog()
        if UserDefaults.standard.string(forKey: "user") != nil && UserDefaults.standard.string(forKey: "Key") != ""
        {
            x = 0
        }
        home.alpha = 1
        favorite.alpha = 0
        profile.alpha = 0
        profile2.alpha = 0
        settings.alpha = 0
        myCart.alpha = 0
    }


    @IBAction func switchViw(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            home.alpha = 1
            favorite.alpha = 0
            profile.alpha = 0
            settings.alpha = 0
            myCart.alpha = 0
        case 1:
            home.alpha = 0
            favorite.alpha = 1
            profile.alpha = 0
            settings.alpha = 0
            myCart.alpha = 0
        case 2:
            home.alpha = 0
            favorite.alpha = 0
            if(x == 1)
            {
            profile.alpha = 1
            profile2.alpha = 0
            }
            else
            {
            profile.alpha = 0
            profile2.alpha = 1
             }
            settings.alpha = 0
             myCart.alpha = 0
        case 3:
            home.alpha = 0
            favorite.alpha = 0
            profile.alpha = 0
            settings.alpha = 1
             myCart.alpha = 0
        case 4:
             myCart.alpha = 1
             home.alpha = 0
             favorite.alpha = 0
             profile.alpha = 0
             settings.alpha = 0
            
        default:
            home.alpha = 1
            favorite.alpha = 0
            profile.alpha = 0
            settings.alpha = 0
            profile2.alpha = 0
              myCart.alpha = 0
        }
    }
    func checklog()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let persistentContainer = appDelegate.persistentContainer
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LogedUser")
        
        do{
            
            let result = try managedContext.fetch(fetchRequest)
            
                if result.count > 0
                {
                    self.x = 0
                }
            
        }catch let error as NSError{
            
            print(error.userInfo)
            
        }
    }
   
}

