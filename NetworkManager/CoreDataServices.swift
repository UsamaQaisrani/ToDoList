//
//  Services.swift
//  ToDoListApp
//
//  Created by Usama Qaisrani on 08/06/2021.
//

import Foundation
import UIKit
import CoreData

class CoreDataServices {
    
    //MARK:- Class Properties
    static let shared = CoreDataServices()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

}

//MARK:- Class Methods
extension CoreDataServices {
    
    func saveData<T>(item: T, completion: @escaping (Result<T?,Swift.Error>)->Void){
        
        do {
            try context.save()
        }
        catch {
            print("Error Saving Context: \(error)")
        }
    }
    
    func loadData<T>(request: NSFetchRequest<T>, completion : @escaping (Result<[T], Swift.Error>)->Void){
        
        do {
            
            let items = try context.fetch(request)
            completion(.success(items))
        }
        catch {
            print("Error Getting Context: \(error)")
            completion(.failure(error))
        }
    }
}
