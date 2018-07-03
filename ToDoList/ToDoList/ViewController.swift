//
//  ViewController.swift
//  ToDoList
//
//  Created by JeremyXue on 2018/7/2.
//  Copyright © 2018年 JeremyXue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTask:[String] = []
    var deleteMode = UITableViewCellEditingStyle.delete
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func changeDeleteMode(_ sender: Any) {
        
        for row in 0...myTask.count - 1{
            listTableView.cellForRow(at: [0,row])?.isSelected = false
        }
        
        if self.navigationItem.leftBarButtonItem?.title == "Single" {
            self.navigationItem.leftBarButtonItem?.title = "Multiple"
            deleteMode = UITableViewCellEditingStyle.insert
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Single"
            deleteMode = UITableViewCellEditingStyle.delete
        }
        
        if listTableView.isEditing {
            setEditing(false, animated: true)
            listTableView.isEditing = false
        }
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        // Check taskTextField text
        if taskTextField.text == "" {
            showAlert()
            return
        }
        
        myTask.append(taskTextField.text!)
        listTableView.insertRows(at: [[0,myTask.count - 1]], with: UITableViewRowAnimation.automatic)
        
        // Scroll to new task position
        listTableView.scrollToRow(at: [0,myTask.count - 1], at: UITableViewScrollPosition.bottom, animated: true)
        
        saveData()
        taskTextField.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        listTableView.setEditing(editing, animated: true)
        
        if deleteMode == UITableViewCellEditingStyle.insert {
            multipleDelete()
            saveData()
        }
    }
    
    // MARK: - Show alert function
    
    func showAlert() {
        let alertController = UIAlertController(title: "錯誤", message: "尚未輸入內容", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Save data & load data
    func saveData() {
        UserDefaults.standard.set(myTask, forKey: "myTask")
    }
    
    func loadData() {
        myTask = UserDefaults.standard.stringArray(forKey: "myTask") ?? []
    }
    
    // MARK: Multiple delete
    func multipleDelete() {
        
        var deleteRows:[Int] = []
        
        for row in 0...myTask.count - 1 {
            if let cell = listTableView.cellForRow(at: [0,row]) {
                if cell.isSelected {
                    deleteRows.append(row)
                }
            }
        }
        
        deleteRows.reversed().forEach { (row) in
            myTask.remove(at: row)
            listTableView.deleteRows(at: [[0,row]], with: UITableViewRowAnimation.fade)
        }
        
    }
    
    // MARK: - Tableview data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = myTask[indexPath.row]
        
        return cell
    }
    
    // MARK: Tableview delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case UITableViewCellEditingStyle.delete:
            myTask.remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        case UITableViewCellEditingStyle.insert:
            if let isSelected = tableView.cellForRow(at: indexPath)?.isSelected {
                tableView.cellForRow(at: indexPath)?.isSelected = !isSelected
            }
        default:
            break
        }
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return deleteMode
    }
    
}

