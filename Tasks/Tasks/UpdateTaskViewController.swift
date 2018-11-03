//
//  UpdateTaskViewController.swift
//  Tasks
//
//  Created by Shubham Gupta on 11/3/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class UpdateTaskViewController: UIViewController {
    
    var task: Item!
    
    @IBOutlet weak var completeTask: UISwitch!
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func updateEntry(_ sender: Any)
    {
        guard let newEntry = entryText.text else  {
            return
        }
        
        task.name = newEntry
        task.isComplete = completeTask.isOn
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var entryText: UITextView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(task)
        configureEntryData(entry: task)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureEntryData(entry: Item) {
        entryText!.text = entry.name ?? "Nothing to update."
        completeTask.isOn = entry.isComplete
    }

 

}
