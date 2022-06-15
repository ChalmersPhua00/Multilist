//
//  BucketListViewController.swift
//  Multilist
//
//  Created by Chalmers Phua on 5/22/22.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController {
    
    var bucketlistArray = [BucketList]()
    var selectedList : List? {
        didSet {
            loadBucketlist()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketlistArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListCell", for: indexPath)
        cell.textLabel?.text = bucketlistArray[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newItem = BucketList(context: self.context)
            newItem.text = textField.text!
            newItem.parentList = self.selectedList
            self.bucketlistArray.append(newItem)
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveBucketlist() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadBucketlist() {
        let request : NSFetchRequest<BucketList> = BucketList.fetchRequest()
        let predicate = NSPredicate(format: "parentList.text MATCHES %@", selectedList!.text!)
        request.predicate = predicate
        do {
            bucketlistArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}
