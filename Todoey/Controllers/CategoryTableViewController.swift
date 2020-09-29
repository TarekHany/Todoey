//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tarek Hany on 9/29/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       loadCategories()
    }

    
    
    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation methods
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        }catch{
            print("Error fetching categories, \(error)")
        }
        tableView.reloadData()
    }
    func saveCategories(){
        do{
            try context.save()
        }catch {
            print("Error saving categories, \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "New category name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil {
                var newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        tableView.reloadData()
    }
}

    


