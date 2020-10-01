//
//  DetailsVC.swift
//  MotorcycleBookWthDatabaseAndCoredata
//
//  Created by mac on 2.10.2020.
//

import UIKit

class DetailsVC: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modelText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func hideKeyboard(){
        
        view.endEditing(true)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        
    }
    
}
