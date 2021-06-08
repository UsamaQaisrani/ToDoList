//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Usama Qaisrani on 07/06/2021.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //MARK:- Class Properties
    var categoriesList = [Categories]()
    let dataViewModel = DataViewModel()
    
    //MARK:- Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

//MARK:- IBActions
extension CategoryViewController {
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            
            if textField.text == "" {
                return
            }
            
            let newCategory = Categories(context: CoreDataServices.shared.context)
            
            newCategory.name = textField.text
            
            self.categoriesList.append(newCategory)
            
            self.saveData()
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- Class Methods
extension CategoryViewController {
    
    fileprivate func initialSetup(){
        
        loadData()
    }
    
    func saveData(item : Categories = Categories()){
                
        dataViewModel.saveData(item: item)
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        
        dataViewModel.loadData(request: request) { items in
            self.categoriesList = items
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesList[indexPath.row].name
        
        return cell
    }
}

//MARK:- UITableViewDelegates
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC = segue.destination as! MainViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            mainVC.selectedCategory = categoriesList[indexPath.row]
        }
    }
}
