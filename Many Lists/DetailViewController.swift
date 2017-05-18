//
//  DetailViewController.swift
//  Many Lists
//
//  Created by Alexander Rinne on 12-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import SQLite

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet var toDoTableView: UITableView!

    @IBOutlet var addToDoButton: UIButton!
    
    @IBAction func addToDo(_ sender: Any) {
       insertNewObject()
    }

    var IDList : Int64 = 0
    var objects = [Any]()

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.objects = ToDoManager.shared.loadToDoTable(listID : self.IDList)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count : Int = ToDoManager.shared.loadToDoTable(listID : self.IDList).count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ToDoTableViewCell
        var toDos = ToDoManager.shared.self.loadToDoTable(listID : self.IDList)
        let toDo = toDos[indexPath.row]
        cell.toDoTextField!.text = toDo.text
        cell.toDoID = toDo.id
        print("Check3: \(String(describing:cell.textLabel!.text))")
        if toDo.checked == 1 {
            cell.checkSwitchOutlet.setOn(true, animated: true)
            
        } else {
            cell.checkSwitchOutlet.setOn(false, animated: false)
        }
        

        return cell

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func insertNewObject() {
        let alert = UIAlertController(title: "To Do", message: "Enter your to do.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
            let text = alert.textFields!.first!.text!
            print(text)
            ToDoManager.shared.insertToDo(toDoText: text,listID: self.IDList)
            self.objects = ToDoManager.shared.loadToDoTable(listID : self.IDList)
            print("Check2: \(self.objects)")
            self.toDoTableView.reloadData()
            
        })
        
        alert.addTextField { (textField) in
            
        }
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var lists = ToDoManager.shared.self.loadToDoTable(listID : self.IDList)
            let list = lists[indexPath.row]
            
            ToDoManager.shared.deleteToDo(ID: list.id)
            self.toDoTableView.reloadData()
            
        } else if editingStyle == .insert {
            
        }
    }

}

