//
//  CheckListViewController.swift
//  Multilist
//
//  Created by Chalmers Phua on 5/22/22.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController {
    
    var checklistArray = [CheckList]()
    var selectedList : List? {
        didSet {
            loadChecklist()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath)
        cell.textLabel?.text = checklistArray[indexPath.row].text
        if checklistArray[indexPath.row].checkmark == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checklistArray[indexPath.row].checkmark = !checklistArray[indexPath.row].checkmark
        saveChecklist()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newItem = CheckList(context: self.context)
            newItem.text = textField.text!
            newItem.checkmark = false
            newItem.parentList = self.selectedList
            self.checklistArray.append(newItem)
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveChecklist() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadChecklist() {
        let request : NSFetchRequest<CheckList> = CheckList.fetchRequest()
        let predicate = NSPredicate(format: "parentList.text MATCHES %@", selectedList!.text!)
        request.predicate = predicate
        do {
            checklistArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}
