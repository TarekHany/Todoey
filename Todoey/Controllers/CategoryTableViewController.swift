//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tarek Hany on 9/29/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController , UIBarPositioningDelegate{
    var realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
             realm = try Realm()
        }catch {
            print(error)
        }
        loadCategories()
    }
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        UIBarPosition.topAttached
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")}
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
        navBar.tintColor = ContrastColorOf(UIColor(hexString: "#1D9BF6")!, returnFlat: true)
        view.backgroundColor = UIColor(hexString: "#1D9BF6")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBar.backgroundColor!, returnFlat: true)]
    }
    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor.init(hexString: categories?[indexPath.row].color ?? "#1D9BF6")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation methods
    
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
        
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
                print("saved ",category)
            }
        }catch {
            print("Error saving categories, \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - Delete from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "New category name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                print(newCategory.name)
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

