//
//  ListViewController.swift
//  Multilist
//
//  Created by Chalmers Phua on 5/22/22.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var listArray = [List]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listArray[indexPath.row].type == 1 {
            performSegue(withIdentifier: "goToBucketList", sender: self)
        } else {
            performSegue(withIdentifier: "goToCheckList", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBucketList" {
            let destinationVC = segue.destination as! BucketListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedList = listArray[indexPath.row]
            }
        } else {
            let destinationVC = segue.destination as! CheckListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedList = listArray[indexPath.row]
            }
        }
    }
    
    func saveLists() {
        do {
            try context.save()
        } catch {
            print("Error saving lists \(error)")
        }
        tableView.reloadData()
    }
    
    func loadLists() {
        let request : NSFetchRequest<List> = List.fetchRequest()
        do {
            listArray = try context.fetch(request)
        } catch {
            print("Error loading lists \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New List", message: "", preferredStyle: .alert)
        let bl_action = UIAlertAction(title: "Add Bucket List", style: .default) { action in
            let newList = List(context: self.context)
            newList.text = textField.text!
            newList.type = 1
            self.listArray.append(newList)
            self.saveLists()
        }
        let cl_action = UIAlertAction(title: "Add Check List", style: .default) { action in
            let newList = List(context: self.context)
            newList.text = textField.text!
            newList.type = 2
            self.listArray.append(newList)
            self.saveLists()
        }
        alert.addAction(bl_action)
        alert.addAction(cl_action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Create New List"
        }
        present(alert, animated: true, completion: nil)
    }
}
