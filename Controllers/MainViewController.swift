//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Usama Qaisrani on 01/06/2021.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    
    //MARK:- Class Properties
    var list = [Item]()
    var selectedCategory: Categories? {
        didSet{
            loadData()
        }
    }
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

//MARK:- IBActions
extension MainViewController {
    
    @IBAction func addButtonItemPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Add New Item To List", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            
            if textField.text == "" {
                return
            }
            
            let newItem = Item(context: CoreDataServices.shared.context)
            
            newItem.title = textField.text
            newItem.checked = false
            newItem.parentCategory = self.selectedCategory
            
            self.list.append(newItem)
            self.saveData(item: newItem)
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- Class Methods
extension MainViewController {
    
    fileprivate func initialSetup(){
        
        
        navigationItem.title = selectedCategory?.name
        searchBar.delegate = self
    }
    
    func saveData(item : Item = Item()){

        let dataViewModel = DataViewModel()
        dataViewModel.saveData(item: item)
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
                    
            let categoryPredicate = NSPredicate(format: "parentCategory.name Matches %@", selectedCategory!.name!)
            let descriptor = NSSortDescriptor(key: "parentCategory", ascending: true)
            
            if let externalPredicate = predicate {
                
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, externalPredicate])
            }
            else {
                request.predicate = categoryPredicate
            }
            
            request.sortDescriptors = [descriptor]
            
        let dataViewModel = DataViewModel()
        
        dataViewModel.loadData(request: request) { items in
            self.list = items
        }
        
        tableView.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = list[indexPath.row]
        
        cell.accessoryType = item.checked  ? .checkmark : .none
        
        cell.textLabel?.text = list[indexPath.row].title
        
        return cell
    }
}

//MARK:- UITableViewDelegate
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = list[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        item.checked = item.checked ? false : true
        
        cell?.accessoryType = item.checked  ? .checkmark : .none
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            CoreDataServices.shared.context.delete(self.list[indexPath.row])
            self.list.remove(at: indexPath.row)
            self.saveData()
            completion(true)
        }
        trash.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        
        return configuration
    }
}

extension MainViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadData()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}
