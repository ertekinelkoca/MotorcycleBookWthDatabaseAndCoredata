//
//  ViewController.swift
//  MotorcycleBookWthDatabaseAndCoredata
//
//  Created by mac on 1.10.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        
        
    }

    
    @objc func addButton(){
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }

}

