//
//  AuctionDetailsViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 12/1/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import CoreData

class AuctionDetailsViewController: UIViewController {

    /*var partsName:String?
    var partsRef:String?
    var partsPrice:String?
    var partsBidPrice:String?
    var partsTime:String?
    var partsDescription:String?
    var partsOther1:String?
    var partsOther2:String?
    var partsOther3:String?*/
    var result:Dictionary<String,Any> = [:]

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var refereance: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bidPrice: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var other1: UILabel!
    @IBOutlet weak var other2: UILabel!
    @IBOutlet weak var other3: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* name.text = partsName
        referance.text = partsRef
        price.text = partsPrice
        bidPrice.text = partsBidPrice
        time.text = partsTime
        desc.text = partsDescription
        other1.text = partsOther1
        other2.text = partsOther2
        other3.text = partsOther3*/
        name.text = result["name"] as! String
        refereance.text = result["refrence"] as! String
        price.text = String(result["Starting_Price"] as! Int)+"$"
        bidPrice.text = String(result["adding_Price"] as! Int)+"$"
        time.text = result["auction_time"] as! String
        desc.text = result["tag_description"] as! String
        other1.text = result["other1"] as! String
        other2.text = result["other2"] as! String
        other3.text = result["other3"] as! String
    }
    
    @IBAction func goBackHome(_ sender: Any) {
        performSegue(withIdentifier: "goBackHomeFromDetailsPartsAuction", sender: self)
    }
    
    @IBAction func addbid(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let persistentContainer = appDelegate.persistentContainer
        
        let managedContext = persistentContainer.viewContext
        
        let BidEntityDescription = NSEntityDescription.entity(forEntityName: "Bids", in: managedContext)
        
        let bidss = NSManagedObject(entity: BidEntityDescription!, insertInto: managedContext)
        
        bidss.setValue(result["idparts"] as! Int, forKey: "id")
        bidss.setValue(result["name"] as! String, forKey: "name")
        bidss.setValue(result["Starting_Price"] as! Int, forKey: "price")
        bidss.setValue(result["auction_time"] as! String, forKey: "time")
        
        
        do{
            
            try  managedContext.save()
            
            let alert = UIAlertController(title: "bidind", message: "your bid has been registered", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            present(alert,animated: true,completion: nil)
            
            
        }catch let error as NSError{
            
            print(error.userInfo)
        }
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let persistentContainer = appDelegate.persistentContainer
        
        let managedContext = persistentContainer.viewContext
        
        let BidEntityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        
        let bidss = NSManagedObject(entity: BidEntityDescription!, insertInto: managedContext)
        
        bidss.setValue(result["idparts"] as! Int, forKey: "id")
        bidss.setValue(result["name"] as! String, forKey: "name")
        bidss.setValue(result["Starting_Price"] as! Int, forKey: "price")
        bidss.setValue(result["auction_time"] as! String, forKey: "time")
        
        
        do{
            
            try  managedContext.save()
            
            let alert = UIAlertController(title: "favorite", message: "add to favorite successfull", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            present(alert,animated: true,completion: nil)
            
            
        }catch let error as NSError{
            
            print(error.userInfo)
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
