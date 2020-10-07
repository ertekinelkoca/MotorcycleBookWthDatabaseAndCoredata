//
//  ViewController.swift
//  MotorcycleBookWthDatabaseAndCoredata
//
//  Created by mac on 1.10.2020.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var selectedMotorcycle = ""
    var selectedMotorcycleID : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @objc func getData(){
        //to overcome redundant datas
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        //app data araştırılacak
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //not known
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Motorcycle")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
            
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "model") as? String {
                    self.nameArray.append(name)
                    
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                    
                }
                self.tableView.reloadData()
                }
            }
        }
        catch{
            print ("error")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMotorcycle = nameArray[indexPath.row]
        selectedMotorcycleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    } 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenMotorcycle = selectedMotorcycle
            destinationVC.chosenMotorcycleID = selectedMotorcycleID
        }
        
    }
    
    @objc func addButton(){
        selectedMotorcycle = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Motorcycle")
        
        let idString = idArray[indexPath.row].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString )
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                
                for result in results as! [NSManagedObject]{
                    
                    if let id = result.value(forKey: "id")! as? UUID {
                        
                        if id == idArray[indexPath.row]{
                            context.delete(result)
                            nameArray.remove(at: indexPath.row)
                            idArray.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            
                            do {
                                try context.save()
                            }
                            catch{
                                print("view controller editing style save error")
                            }
                            break
                        }
                    }
                }
            }
        }
        
        catch {
            print("persistence error")
            
        }
        
    }
}
