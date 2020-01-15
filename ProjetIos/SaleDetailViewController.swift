//
//  AuctionDetailsViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 12/1/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import DateToolsSwift


class SaleDetailsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var result:Dictionary<String,Any> = [:]
    var comments:NSArray = []
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var refereance: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var other1: UILabel!
    @IBOutlet weak var other2: UILabel!
    @IBOutlet weak var other3: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var comment: UITableView!
    @IBOutlet weak var vues: UILabel!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var labele1 = result["other1"] as? String
        var labele2 = result["other2"] as? String
        var labele3 = result["other3"] as? String
        
        if (labele1 == "") {
            labele1 = " , "
            other1.isHidden = true
            label1.isHidden = true
        }
        if (labele2 == "") {
            labele2 = " , "
            other2.isHidden = true
            label2.isHidden = true
        }
        if (labele3 == "") {
            labele3 = " , "
            other3.isHidden = true
            label3.isHidden = true
        }
        
        let content1 = labele1?.components(separatedBy: ",")
        let content2 = labele2?.components(separatedBy: ",")
        let content3 = labele3?.components(separatedBy: ",")
        type.text = result["Type"] as! String
        name.text = result["name"] as! String
        refereance.text = result["refrence"] as! String
        price.text = String(result["Price"] as! Double)+"TND"
        time.text = timeAgo(date : result["Created"] as! String)
        desc.text = result["tag_description"] as! String
        other1.text = content1?[0]
        other2.text = content2?[0]
        other3.text = content3?[0]
        label1.text = content1?[1]
        label2.text = content2?[1]
        label3.text = content3?[1]
       
        getComments(dealId: result["idparts"] as! Int)
        updateViews(idParts: result["idparts"] as! Int)
        vues.text = String(result["vues"] as! Int+1)
        
        if (result["String_image"] as! String) != nil && (result["String_image"] as! String) != ""{
            let dataDecoded : Data = Data(base64Encoded: result["String_image"] as! String, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            image.image = decodedimage
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment")
        let contentView = cell?.viewWithTag(0)
        let comentLogo = contentView?.viewWithTag(1) as! UILabel
        let comentName = contentView?.viewWithTag(2) as! UILabel
        let comentDate = contentView?.viewWithTag(3) as! UILabel
        let comentContent = contentView?.viewWithTag(4) as! UITextView
        let comentNumberLike = contentView?.viewWithTag(5) as! UILabel
        let comentLike = contentView?.viewWithTag(6) as! UIButton
        let comentDeslike = contentView?.viewWithTag(7) as! UIButton
        
        let commentIndividual = comments[indexPath.row] as! Dictionary<String,Any>
        comentName.text = (commentIndividual["firstname"] as! String)+" "+(commentIndividual["lastname"] as! String)
        let logo = commentIndividual["lastname"] as! String
        comentLogo.text = String(logo[logo.startIndex]).uppercased()
        comentContent.text = commentIndividual["text"] as! String
        comentNumberLike.text = String(commentIndividual["votes"] as! Int)

        
        comentDate.text = timeAgo(date: commentIndividual["created"] as! String)
        
        return cell!
    }
    
    
    
    
    @IBAction func goBackHome(_ sender: Any) {
        performSegue(withIdentifier: "goBackHomeFromDetailsPartsAuction", sender: self)
    }
    
    @IBAction func contactOwner(_ sender: Any) {
        performSegue(withIdentifier: "toContactViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toContactViewController"
    {
        let toContactViewController = segue.destination as! ContactViewController
        
        toContactViewController.info = result
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
        bidss.setValue(result["Price"] as! Double, forKey: "price")
        bidss.setValue(result["Created"] as! String, forKey: "time")
        
        
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
    
    func getComments(dealId:Int)
    {
        Alamofire.request( Server.ip+"api/comments/getComments",method: .post, parameters:["dealid" : dealId],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            if let arrayVersion = response.result.value as? NSArray
            {
               self.comments = response.result.value as! NSArray
            }
            else if let dictionaryVersion = response.result.value as? NSDictionary
            {
            }
            //self.comments = response.result.value as! NSArray
            
            self.comment.reloadData()
             }
    }
    func getUser(userName:String) -> String
    {
        var namePrenom:String = ""
        var users:NSArray = []
        var user:Dictionary<String,Any> = [:]
        Alamofire.request( Server.ip+"api/getUser",method: .post, parameters:["username" : userName],encoding: JSONEncoding.default ) .responseJSON{ response in
            users = response.result.value as! NSArray
            user = users[0] as! Dictionary<String,Any>
            namePrenom = (user["firstname"] as! String)+" "+(user["lastname"] as! String)
        }
        return namePrenom
    }
    func timeAgo(date:String) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: date)
        return date!.timeAgoSinceNow
    }
    
    func updateViews(idParts : Int) {
        Alamofire.request( Server.ip+"api/parts/UpdateVues",method: .put, parameters:["idparts" : idParts],encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
        }
    }
    @IBAction func hideShowComments(_ sender: Any) {
        if comment.isHidden == true
        {
            comment.isHidden = false
        }
        else
        {
            comment.isHidden = true
        }
    }
    @IBAction func postComment(_ sender: Any) {
        if text.text != ""
        {
            postComments(idParts: result["idparts"] as! Int, username: UserDefaults.standard.string(forKey: "user")!, comment: text.text! )
        }
    }
    func postComments(idParts:Int , username:String , comment:String)
    {
        let param = ["dealid" : idParts,"username" : username, "text" : comment] as [String : Any]
        
        Alamofire.request( Server.ip+"api/comments/addComment",method: .post, parameters:param,encoding: JSONEncoding.default ) .responseJSON{ response in
            print(response)
            self.comment.reloadData()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
     let persistentContainer = appDelegate.persistentContainer
     
     let managedContext = persistentContainer.viewContext
     
     let BidEntityDescription = NSEntityDescription.entity(forEntityName: "Bids", in: managedContext)
     
     let bidss = NSManagedObject(entity: BidEntityDescription!, insertInto: managedContext)
     
     bidss.setValue(result["idparts"] as! Int, forKey: "id")
     bidss.setValue(result["name"] as! String, forKey: "name")
     bidss.setValue(result["Price"] as! Int, forKey: "price")
     bidss.setValue(result["Created"] as! String, forKey: "time")
     
     
     do{
     
     try  managedContext.save()
     
     let alert = UIAlertController(title: "bidind", message: "your bid has been registered", preferredStyle: .alert)
     
     let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
     
     alert.addAction(action)
     
     present(alert,animated: true,completion: nil)
     
     
     }catch let error as NSError{
     
     print(error.userInfo)
     }
     */
    
}
