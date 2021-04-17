//
//  DatabaseManager.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    private init() {}
    static let shared = DatabaseManager()
    
    var context: NSManagedObjectContext? {
        get {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                return delegate.persistentContainer.viewContext
            }
            return nil
        }
    }
    
    var currentUser: UserProfile?
    
    func saveNewUserNameAndPassword(name: String, password: String) {
        
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: "User", in: context)  {
            
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            newUser.setValue(UUID().uuidString, forKey: "userID")
            newUser.setValue(name, forKey: "username")
            newUser.setValue(password, forKey: "password")
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func validateUserNameAndPassword(name: String, password: String, onSuccess: (Bool) -> Void) {
        if let context = context  {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "username == %@ && password == %@", name, password)
            
            do {
                let result = try context.fetch(request)
                
                if let resultData = result as? [NSManagedObject], resultData.count > 0 {
                 
                    if let id = resultData.first?.value(forKey: "userID") as? String, let name = resultData.first?.value(forKey: "username") as? String {
                        currentUser = UserProfile(userID: id, userName: name)
                        onSuccess(true)
                    } else {
                        onSuccess(false)
                    }
                } else {
                    onSuccess(false)
                }
            } catch {
                onSuccess(false)
            }
        }
    }
    
    func saveNewOrderDetails(order: OrderDetail) {
        
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: "Order", in: context) {
            
            let newOrder = NSManagedObject(entity: entity, insertInto: context)
    
            newOrder.setValue(UUID().uuidString, forKey: "orderNumber")
            newOrder.setValue(currentUser?.userID, forKey: "userID")
            newOrder.setValue(order.dueDate, forKey: "dueDate")
            newOrder.setValue(order.customerName, forKey: "customerName")
            newOrder.setValue(order.customerAddress, forKey: "customerAddress")
            newOrder.setValue(order.customerPhone, forKey: "customerPhone")
            newOrder.setValue(order.orderTotal, forKey: "orderTotal")
    
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func fetchAllOrders(onSuccess: ([OrderDetail]) -> Void, onFailure: () -> Void) {
        if let context = context  {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
            
            request.predicate = NSPredicate(format: "userID == %@", currentUser!.userID!)

            do {
                let result = try context.fetch(request)
                
                if let resultData = result as? [NSManagedObject], resultData.count > 0 {
                 
                    var orders: [OrderDetail] = []
                    
                    for data in resultData {
                        
                        if let address = data.value(forKey: "customerAddress") as? String, let name = data.value(forKey: "customerName") as? String, let phone = data.value(forKey: "customerPhone") as? String, let dueDate = data.value(forKey: "dueDate") as? Date, let orderNumber = data.value(forKey: "orderNumber") as? String, let total = data.value(forKey: "orderTotal") as? Float  {
                            
                            let order = OrderDetail(customerAddress: address, customerName: name, customerPhone: phone, dueDate: dueDate, orderNumber: orderNumber, orderTotal: total)
                            
                            orders.append(order)
                        }
                    }
                    onSuccess(orders)
                }
            } catch {
                onFailure()
            }
        }
    }
    
    func deleteOrder(order: OrderDetail) {
        if let context = context  {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
            fetchRequest.predicate = NSPredicate(format: "orderNumber == %@", order.orderNumber!)
            
            do {
                let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
                
                if let resultData = fetchedResults, resultData.count > 0 {
                    for entity in resultData {
                        context.delete(entity)
                    }
                }
            }
            catch _ { }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func editOrder(order: OrderDetail) {
        if let context = context  {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
            fetchRequest.predicate = NSPredicate(format: "orderNumber == %@", order.orderNumber!)
            
            do {
                let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
                
                if let resultData = fetchedResults, resultData.count > 0 {
                    resultData.first?.setValue(order.dueDate, forKey: "dueDate")
                    resultData.first?.setValue(order.customerName, forKey: "customerName")
                    resultData.first?.setValue(order.customerAddress, forKey: "customerAddress")
                    resultData.first?.setValue(order.customerPhone, forKey: "customerPhone")
                    resultData.first?.setValue(order.orderTotal, forKey: "orderTotal")
                }
            }
            catch _ { }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
}
