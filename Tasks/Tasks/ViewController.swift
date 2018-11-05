//
//  ViewController.swift
//  Tasks
//
//  Created by Shubham Gupta on 11/3/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks : [Item] = []
    var selectedIndex: Int!
    var filteredData: [Item] = []
   
    
    
    @IBOutlet weak var completeButton: UISwitch!
    @IBOutlet weak var tableViewContent: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableViewContent.estimatedRowHeight = 44
        self.tableViewContent.rowHeight = UITableViewAutomaticDimension
        tableViewContent.dataSource = self
        tableViewContent.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showComplete(_ sender: Any) {
        if completeButton.isOn == false {
           
           filteredData = tasks
            
           
        } else {

            filteredData = tasks.filter ( { $0.isComplete == true } )
        }
        
        DispatchQueue.main.async {
            
           self.tableViewContent.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getData()
         completeButton.isOn = false
         DispatchQueue.main.async {
            self.tableViewContent.reloadData()
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
        tasks = try context.fetch(Item.fetchRequest())
            filteredData = tasks
            DispatchQueue.main.async {
                self.tableViewContent.reloadData()
            }
        } catch {
            print("fetching failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateVC" {
            let updateVC = segue.destination as! UpdateTaskViewController
            updateVC.task = filteredData[selectedIndex!]
        }
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableViewContent.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let task = filteredData[indexPath.row]
        
        if task.isComplete {
            cell.textLabel?.text = " ✔︎ \(task.name!)"
        } else {
             cell.textLabel?.text = task.name
            
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            let item = self.filteredData[indexPath.row]
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        delete.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "UpdateVC", sender: self)
    }


}

