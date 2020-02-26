//
//  ListPartsController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/27/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire
import AlamofireImage

class ListPartsController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var myParts:NSArray = []
    
    @IBOutlet weak var myPartsTab: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myParts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myParts")
        let contentView = cell?.viewWithTag(0)
        
        let partsName = contentView?.viewWithTag(2) as! UILabel
        let startingPrice = contentView?.viewWithTag(3) as! UILabel
        let image = contentView?.viewWithTag(1) as! UIImageView
        //let finalPrice = contentView?.viewWithTag(4) as! UILabel
        let result = myParts[indexPath.row] as! Dictionary<String,Any>
        partsName.text = result["name"] as! String
        startingPrice.text =  result["Type"] as! String
        if (result["String_image"] as! String) != nil && (result["String_image"] as! String) != ""{
            let dataDecoded : Data = Data(base64Encoded: result["String_image"] as! String, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            image.image = decodedimage
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let result = myParts[indexPath.row] as! Dictionary<String,Any>
        
        if (editingStyle == .delete) {
            removePart(idPart: result["idparts"] as! Int )
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailsMyPartsViewController", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsMyPartsViewController"
        {
        let indexPath = sender as! IndexPath
        
        let indice = indexPath.row
        
        let result = myParts[indice] as! Dictionary<String,Any>
        
        let detailsMyPartsViewController = segue.destination as! detailsMyPartsViewController
        
        detailsMyPartsViewController.result = result
        }
        
    }
    
    func removePart(idPart:Int){
        Alamofire.request( Server.ip+"api/parts/deletePart",method: .delete, parameters:["deleteId" : idPart],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            print(response)
            self.myPartsTab.reloadData()
        }
    }

    
    /*@IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "addingParts", sender: self)
    }*/
    
    func updatePart(idPart:Int){
        Alamofire.request( Server.ip+"api/parts/deletePart",method: .put, parameters:["partId" : idPart],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            print(response)
            self.myPartsTab.reloadData()
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
fetchMyParts()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func fetchMyParts(){
        Alamofire.request( Server.ip+"api/parts/myparts",method: .post, parameters:["username" : UserDefaults.standard.string(forKey: "user")],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            if let arrayVersion = response.result.value as? NSArray
            {
            self.myParts = response.result.value as! NSArray
            }
            self.myPartsTab.reloadData()
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
