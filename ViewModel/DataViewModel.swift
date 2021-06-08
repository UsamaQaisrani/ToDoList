//
//  DataViewModel.swift
//  ToDoListApp
//
//  Created by Usama Qaisrani on 08/06/2021.
//

import Foundation
import CoreData

class DataViewModel {
    
    
    func saveData<T>(item: T) {
        
        CoreDataServices.shared.saveData(item: item) { result in
            
            switch result {
            case .success(_):
                print("Context Saved")
            case .failure(_):
                print("Context Not Saved")
            }
        }
    }
    
    func loadData<T>(request: NSFetchRequest<T>, completion: @escaping ([T])->Void){
        
        CoreDataServices.shared.loadData(request: request) { result in
            
            switch result {
            case .success(let items):
                completion(items)
            case .failure(_):
                print("Error Getting Data")
            }
        }
    }
}
