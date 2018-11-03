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
  
    @IBOutlet weak var tableViewContent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewContent.estimatedRowHeight = 44
        self.tableViewContent.rowHeight = UITableViewAutomaticDimension
        tableViewContent.dataSource = self
        tableViewContent.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        
        tableViewContent.reloadData()
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
        tasks = try context.fetch(Item.fetchRequest())
        } catch {
            print("fetching failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateVC" {
            let updateVC = segue.destination as! UpdateTaskViewController
            updateVC.task = tasks[selectedIndex!]
        }
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        let task = tasks[indexPath.row]
        if task.isComplete {
            cell.textLabel?.text = " ✔︎ \(task.name!)"
        } else {
             cell.textLabel?.text = task.name!
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let task = tasks[(indexPath.row)]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                tasks = try context.fetch(Item.fetchRequest())
            } catch {
                print("fetching failed")
            }
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "UpdateVC", sender: self)
    }


}

