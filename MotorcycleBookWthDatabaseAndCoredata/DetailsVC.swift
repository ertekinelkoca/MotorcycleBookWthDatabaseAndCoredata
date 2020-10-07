//
//  DetailsVC.swift
//  MotorcycleBookWthDatabaseAndCoredata
//
//  Created by mac on 2.10.2020.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modelText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenMotorcycle = ""
    var chosenMotorcycleID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenMotorcycle != ""{
            //Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Motorcycle")
           
            let idString = chosenMotorcycleID?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@",idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
              let results = try  context.fetch(fetchRequest)
            
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        
                        if let model = result.value(forKey: "model") as? String{
                            modelText.text = model
                        }
                        if let type = result.value(forKey: "type") as? String{
                            typeText.text = type
                        }
                        if let year = result.value(forKey: "year") as? Int{
                            yearText.text = String(year)
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            
            }catch{
                print("detailsVC persistence error")
            }
            
        }
        else{
            modelText.text = ""
            yearText.text = ""
            typeText.text = ""
        }
                
        //Recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
         
        // to make image clickable
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    //to redirect user to gallery
    @objc func selectImage(){
        
        //to reach users media and libraries
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newMotorcycle = NSEntityDescription.insertNewObject(forEntityName: "Motorcycle", into: context)
        
        //attributes
        newMotorcycle.setValue(modelText.text, forKey: "model")
        newMotorcycle.setValue(typeText.text, forKey: "type")
        if let year = Int(yearText.text!){
            
            newMotorcycle.setValue(year, forKey: "year")
        }
        newMotorcycle.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.pngData()
        newMotorcycle.setValue(data, forKey: "image")
        
        do{
            try context.save()
            print("success")
        }catch{
            print("error")
        }
  
        //this enables to send message to other controllers.
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
