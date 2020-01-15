//
//  MyCartController.swift
//  ProjetIos
//
//  Created by Taha Chaouch on 11/28/19.
//  Copyright © 2019 jawheriheb. All rights reserved.
//

import UIKit
import CoreData
class MyCartController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //let cars = ["car"]
    var ids = [Int]()
    var cars = [String]()
    var prices = [String]()
    var times = [String]()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cars.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCart")
        let contentView = cell?.viewWithTag(0)

        let partsName = contentView?.viewWithTag(1) as! UILabel
        let partsPrice = contentView?.viewWithTag(2) as! UILabel
        let partsTime = contentView?.viewWithTag(3) as! UILabel
       
        partsName.text = cars[indexPath.row]
        partsPrice.text = prices[indexPath.row]+"TND"
        partsTime.text = times[indexPath.row]
       
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.cars.remove(at: indexPath.row)
            self.times.remove(at: indexPath.row)
            self.prices.remove(at: indexPath.row)
            removePart(id: ids[indexPath.row])
            self.ids.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
tabfill()
        // Do any additional setup after loading the view.
    }
    func tabfill(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let persistentContainer = appDelegate.persistentContainer
    
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bids")
    
    do{
    
    let result = try managedContext.fetch(fetchRequest)
    
    do {
    
    for data in result as! [NSManagedObject] {
        cars.append(data.value(forKey: "name") as! String)
        prices.append(String(data.value(forKey: "price") as! Float))
        times.append(data.value(forKey: "time") as! String)
        ids.append(data.value(forKey: "id") as! Int)
        
    }
    
    }
    
    
    
    }catch let error as NSError{
    
    print(error.userInfo)
    
    }
    }
    
    func removePart(id:Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bids")
        
        do{
            
            let result = try managedContext.fetch(fetchRequest)
            
            do {
                
                for data in result as! [NSManagedObject] {
                 if data.value(forKey: "id") as! Int == id
                 {
                    managedContext.delete(data)
                    try managedContext.save()
                 }
                    
                }
                
            }
            
            
            
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
