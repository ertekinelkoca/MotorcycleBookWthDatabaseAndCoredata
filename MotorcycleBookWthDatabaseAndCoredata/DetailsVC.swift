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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
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
        
    }
    
}
