//
//  ViewController.swift
//  CarOwners
//
//  Created by Aleksandr Afanasiev on 15.08.17.
//  Copyright © 2017 Aleksandr Afanasiev. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var dataTableView: UITableView!
    
    var dataArray = [NSManagedObject]()
    var dataType: Type = .Owner
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData(type: .Owner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
    
    }
    
    @IBAction func changeState(_ sender: UISegmentedControl) {
        dataType = dataType == .Owner ? .Car : .Owner
        print(dataType)
        self.getData(type: dataType)
    }
    
    @IBAction func addData(_ sender: UIBarButtonItem) {
        
        let addAlert = UIAlertController(title: "Add new owner", message: "Please enter owner name", preferredStyle: .alert)
        addAlert.addTextField {$0.text = "Enter name"}
        let addAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            let name = addAlert.textFields![0].text
            _ = DatabaseManager.shared.addData(name: name!, type: self.dataType)
            self.getData(type: self.dataType)
            self.dataTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        addAlert.addAction(addAction)
        addAlert.addAction(cancelAction)
        
        self.present(addAlert, animated: true) { 
//            self.getData(type: self.dataType)
//            self.dataTableView.reloadData()
        }
        
    }
    
    func getData(type: Type) {
//        if segmentSelector.selectedSegmentIndex == 0{
//            self.dataArray =  DatabaseManager.shared.getAllData(type: .Owner)
//        }else{
//            self.dataArray = DatabaseManager.shared.getAllData(type: .Car)
//        }

        self.dataArray = DatabaseManager.shared.getAllData(type: type)
        self.dataTableView.reloadData()
    }
}



































extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editAlert = UIAlertController(title: "Edit your \(dataType) name", message: "Please edit data", preferredStyle: .alert)
        if let name = dataArray[indexPath.row].value(forKey: "name") as? String {
            editAlert.addTextField {$0.text = name}
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            let name = editAlert.textFields![0].text
            _ = DatabaseManager.shared.editDataById(objectID: self.dataArray[indexPath.row].objectID, newValue: name!)
            
            
           // _ = DatabaseManager.shared.addData(name: name!, type: self.dataType)
            self.getData(type: self.dataType)
            self.dataTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        editAlert.addAction(okAction)
        editAlert.addAction(cancelAction)
        
        self.present(editAlert, animated: true) {
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = self.segmentSelector.selectedSegmentIndex == 0 ? DatabaseManager.shared.deleteDataById(id: self.dataArray[indexPath.row].objectID) :
                DatabaseManager.shared.deleteDataById(id: self.dataArray[indexPath.row].objectID)
            self.getData(type: self.dataType)
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        
        if let name = dataArray[indexPath.row].value(forKey: "name") as? String {
            cell?.textLabel?.text = name
        }
        
        return cell!
    }
    
}
