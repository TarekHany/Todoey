//
//  ViewController.swift
//  Todoey
//
//  Created by Tarek Hany on 9/28/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController, UIBarPositioningDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        UIBarPosition.topAttached
    }
    //MARK: - table view DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            if let item = todoItems?[indexPath.row] {
                cell.accessoryType = item.done ? .checkmark: .none
                cell.textLabel?.text = item.title
                cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count) / 3)
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
                cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)

            }else {
                cell.textLabel?.text = "No items added"
            }
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar  else {fatalError("Navigation controller does not exist.")}
            
            
            if let color = UIColor(hexString: colorHex) {
                searchBar.barTintColor = color
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
                navBar.backgroundColor = color
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
                view.backgroundColor = color
            }
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do{
                    if let newName = textField.text {
                    try self.realm.write{
                            let newItem = Item()
                            newItem.title = newName
                            newItem.date = Date()
                            currentCategory.items.append(newItem)
                        }
                        
                    }
                }catch {
                    print(error)
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New item name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    //MARK: - Delete from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemForDeletion)
                   // self.realm.delete(itemForDeletion.parentCategory)
                }
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
