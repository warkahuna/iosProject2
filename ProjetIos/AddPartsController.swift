//
//  AddPartsController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/29/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import Alamofire

class AddPartsController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var referance: UITextField!
    @IBOutlet weak var desc: UITextView!
    //@IBOutlet weak var desc: UITextField!
    @IBOutlet weak var other1: UITextField!
    @IBOutlet weak var other2: UITextField!
    @IBOutlet weak var other3: UITextField!
    @IBOutlet weak var other1Content: UITextField!
    @IBOutlet weak var other2Content: UITextField!
    //@IBOutlet weak var price: UITextField!
    @IBOutlet weak var other3Content: UITextField!
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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImage(_ sender: Any) {
        /*let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        /*alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))*/

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        /*let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)*/
 */
        ImagePickerManager().pickImage(self){ images in
            self.image.image = images
        }
    }
    /*func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            image.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image_data = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        image.image = image_data
        let imageData:Data = image_data.pngData()!
        let imageStr = imageData.base64EncodedString()
        //print(imageStr)
        self.dismiss(animated: true, completion: nil)
    }*/*/
    
    @IBAction func addPart(_ sender: Any) {
        let imageData:Data = (image.image?.pngData()!)!
        let imageStr = imageData.base64EncodedString()
        //let owner = "Jawhera@yahoo.fr"
        let owner = UserDefaults.standard.string(forKey: "user")
        let param = ["username" : owner,"name" : name.text! , "refrence" : referance.text! , "Type":type, "tag_description" : desc.text!, "other1":other1.text!+","+other1Content.text!,"other2":other2.text!+","+other2Content.text!,"other3":other3.text!+","+other3Content.text!,"String_image": " "]
       print(param)
        
        Alamofire.request( Server.ip+"api/parts/add",method: .post, parameters:param , encoding: JSONEncoding.default ) .responseString{ response in
            print(response)
            let alert = UIAlertController(title: "new part", message: "the new part have been added successfully", preferredStyle: .alert)
            
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
