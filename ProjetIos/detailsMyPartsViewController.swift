//
//  detailsMyPartsViewController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 12/5/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire
class detailsMyPartsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var result:Dictionary<String,Any> = [:]
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var referance: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var other1: UITextField!
    @IBOutlet weak var other2: UITextField!
    @IBOutlet weak var other3: UITextField!
    @IBOutlet weak var other1Content: UITextField!
    @IBOutlet weak var other2Content: UITextField!
    @IBOutlet weak var other3Content: UITextField!
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var sellingSwitch: UISwitch!
    @IBOutlet weak var selling: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    let types = ["Brakes","Exhaust"]
    var type:String = "Brakes"
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = types[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.isEnabled = false
        let label1 = result["other1"] as? String
        let label2 = result["other2"] as? String
        let label3 = result["other3"] as? String
        let content1 = label1?.components(separatedBy: ",")
        let content2 = label2?.components(separatedBy: ",")
        let content3 = label3?.components(separatedBy: ",")
        
        name.text = result["name"] as? String
        referance.text = result["refrence"] as? String
        desc.text = result["tag_description"] as? String
        other1.text = content1![0]
        other2.text = content2![0]
        other3.text = content3![0]
        other1Content.text = content1![1]
        other2Content.text = content2![1]
        other3Content.text = content3![1]
        
        if (result["String_image"] as! String) != nil && (result["String_image"] as! String) != ""{
        let dataDecoded : Data = Data(base64Encoded: result["String_image"] as! String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        image.image = decodedimage
        }
        //price.text = String(result["Price"] as! Int)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sellSwitch(_ sender: UISwitch) {
        if sender.isOn
        {
            price.isEnabled = true
        }
        else
        {
            price.isEnabled = false
        }
    }
    
    @IBAction func deletePart(_ sender: Any) {
        removePart(idPart: result["idparts"] as! Int)
    }
    
    @IBAction func updatePart(_ sender: Any) {
       
        updatePart()
    }
    
    @IBAction func sellPart(_ sender: Any) {
        if sellingSwitch.isOn
        {
        sellPart()
        }
    }
    func updatePart(){
        let param = ["idparts": result["idparts"],"name" : name.text!,"refrence" : referance.text! , "Type": type, "tag_description" : desc.text!, "other1":other1.text!+","+other1Content.text!,"other2":other2.text!+","+other2Content.text!,"other3":other3.text!+","+other3Content.text! ]
        Alamofire.request( Server.ip+"api/parts/updatePart",method: .put, parameters: param,encoding: JSONEncoding.default ) .responseJSON{ response in
            
            let alert = UIAlertController(title: "update part", message: "the part have been updated successfully", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true,completion: nil)
            
        }
    }
    
    func removePart(idPart:Int){
        Alamofire.request( Server.ip+"api/parts/deletePart",method: .delete, parameters:["deleteId" : idPart],encoding: JSONEncoding.default ) .responseJSON{ response in
            
            let alert = UIAlertController(title: "delete part", message: "the part have been deleted successfully", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true,completion: nil)
            
        }
    }
    
    func sellPart(){
        let param = ["idparts": result["idparts"] ,"price" : price.text!]
        Alamofire.request( Server.ip+"api/parts/addSell",method: .put, parameters: param,encoding: JSONEncoding.default ) .responseJSON{ response in

            let alert = UIAlertController(title: "sell part", message: "the part have been put on sale successfully", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true,completion: nil)
            
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
