//
//  AddTasksViewController.swift
//  Tasks
//
//  Created by Shubham Gupta on 11/3/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class AddTasksViewController: UIViewController, UITextViewDelegate {

    @IBAction func backButton(_ sender: Any) {
     dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var taskComplete: UISwitch!
    @IBOutlet weak var textField: UITextView!
   
    @IBAction func addTaskButton(_ sender: Any) {
        
        guard let textEntry = textField?.text else {
            return
        }
        
        if textEntry.isEmpty || textField?.text == "Type task here.."{
            let alert = UIAlertController(title:"Please Type Task", message: "Entry is Blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
        })
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            guard let entryText = textField?.text else {
                return
            }
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let task = Item(context: context)
            task.name = entryText
            task.isComplete = taskComplete.isOn
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.delegate = self

        // Do any additional setup after loading the view.
    }


}
