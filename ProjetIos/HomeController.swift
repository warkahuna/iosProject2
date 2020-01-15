//
//  HomeController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/21/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage
import CoreData
import FacebookLogin
import FacebookCore

class HomeController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var carParts: UITableView!
    
    
    var carsParts:NSArray = []
    var part2:Dictionary<String,Any> = [:]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carsParts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "carParts")
        
        let contentView = cell?.viewWithTag(0)
        
        let partsName = contentView?.viewWithTag(2) as! UILabel
        let partsPrice = contentView?.viewWithTag(3) as! UILabel
        let partsType = contentView?.viewWithTag(4) as! UILabel
        let partsOwner = contentView?.viewWithTag(5) as! UILabel
        let partsLabel1 = contentView?.viewWithTag(6) as! UILabel
        let partsContent1 = contentView?.viewWithTag(7) as! UILabel
        let partsLabel2 = contentView?.viewWithTag(8) as! UILabel
        let partsContent2 = contentView?.viewWithTag(9) as! UILabel
        let partsLabel3 = contentView?.viewWithTag(10) as! UILabel
        let partsContent3 = contentView?.viewWithTag(13) as! UILabel
        let partsVues = contentView?.viewWithTag(14) as! UILabel
        let image = contentView?.viewWithTag(1) as! UIImageView
        
        let result = carsParts[indexPath.row] as! Dictionary<String,Any>

        //let parts = result["results"] as! NSArray
    
        //part2 = parts[indexPath.row] as! Dictionary<String,Any>
        part2 = result
        
     /*let bid = contentView?.viewWithTag(11) as! UIButton
    let favorites = contentView?.viewWithTag(12) as! UIButton
        bid.tag = indexPath.row+10
        favorites.tag = indexPath.row+10*/
        
        var label1 = result["other1"] as? String
        var label2 = result["other2"] as? String
        var label3 = result["other3"] as? String
     
        if (label1 == "") {
            label1 = " , "
            partsContent1.isHidden = true
            partsLabel1.isHidden = true
        }
        if (label2 == "") {
            label2 = " , "
            partsContent2.isHidden = true
            partsLabel2.isHidden = true
        }
        if (label3 == "") {
            label3 = " , "
            partsContent3.isHidden = true
            partsLabel3.isHidden = true
        }
        
        let content1 = label1?.components(separatedBy: ",")
        
        let content2 = label2?.components(separatedBy: ",")
        let content3 = label3?.components(separatedBy: ",")
        
        
        partsName.text = part2["name"] as! String
        partsType.text = part2["Type"] as! String
        partsOwner.text = part2["owner"] as! String
        partsVues.text = String(part2["vues"] as! Int)
        //partsRef.text = part2["refrence"] as! String
        partsPrice.text = String( part2["Price"] as! Double)+"$"
        //partsBidPrice.text = /*String( part2["adding_Price"] as! Int)+*/"$"
        //partsTime.text = /*part2["auction_time"] as! String*/"0h"
        //partsDescription.text = part2["tag_description"] as! String
        partsLabel1.text = content1?[0]
        partsLabel2.text = content2?[0]
        partsLabel3.text = content3?[0]
        partsContent1.text = content1?[1]
        partsContent2.text = content2?[1]
        partsContent3.text = content3?[1]
        
        let dataDecoded : Data = Data(base64Encoded: part2["String_image"] as! String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        image.image = decodedimage
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toPartsDetails", sender: indexPath)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = sender as! IndexPath
        
        let indice = indexPath.row
        
        let result = carsParts[indice] as! Dictionary<String,Any>
        
        let saleDetailsViewController = segue.destination as! SaleDetailsViewController
        
        saleDetailsViewController.result = result
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchParts()
        
        // Do any additional setup after loading the view.
    }
    

    func fetchParts(){
        
        Alamofire.request(Server.ip+"api/parts/getSells").responseJSON{ response in
           
            self.carsParts = response.result.value as! NSArray
            self.carParts.reloadData()
         }
        }
    
    

    /*@IBAction func bider(_ sender: Any) {
        let bids: UIButton = sender as! UIButton;

        let result = carsParts[bids.tag-10] as! Dictionary<String,Any>
        
        //let parts = result["results"] as! NSArray
        
        //part2 = parts[bids.tag-10] as! Dictionary<String,Any>
        
        part2 = result
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let persistentContainer = appDelegate.persistentContainer
        
        let managedContext = persistentContainer.viewContext
        
        let BidEntityDescription = NSEntityDescription.entity(forEntityName: "Bids", in: managedContext)
        
        let bidss = NSManagedObject(entity: BidEntityDescription!, insertInto: managedContext)
        
         bidss.setValue(part2["idparts"] as! Int, forKey: "id")
        bidss.setValue(part2["name"] as! String, forKey: "name")
        bidss.setValue(part2["Price"] as! Int, forKey: "price")
        bidss.setValue(part2["Created"] as! String, forKey: "time")
        
        
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
    
    @IBAction func addFacorite(_ sender: Any) {
            
            let favorite: UIButton = sender as! UIButton;
            
            let result = carsParts[favorite.tag-10] as! Dictionary<String,Any>
            
            //let parts = result["results"] as! NSArray
            
            //part2 = parts[favorite.tag-10] as! Dictionary<String,Any>
        
            part2 = result
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let persistentContainer = appDelegate.persistentContainer
            
            let managedContext = persistentContainer.viewContext
            
            let BidEntityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
            
            let bidss = NSManagedObject(entity: BidEntityDescription!, insertInto: managedContext)
            
            bidss.setValue(part2["idparts"] as! Int, forKey: "id")
            bidss.setValue(part2["name"] as! String, forKey: "name")
            bidss.setValue(part2["Price"] as! Int, forKey: "price")
            bidss.setValue(part2["Created"] as! String, forKey: "time")
            
            
            do{
                
                try  managedContext.save()
                
                let alert = UIAlertController(title: "favorite", message: "add to favorite successfull", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                
                alert.addAction(action)
                
                present(alert,animated: true,completion: nil)
                
                
            }catch let error as NSError{
                
                print(error.userInfo)
            }
        }*/
    
}

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    

        

