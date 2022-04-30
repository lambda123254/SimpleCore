import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
public class SimpleCore{
    var entity: String
    var coreDataName: String
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: coreDataName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public init(entity: String, coreData: String) {
        self.entity = entity
        self.coreDataName = coreData
    }
    
    public func insert(into: String, value: String){
        let attrArr = into.components(separatedBy: ",")
        let unsortedVal = value.split(separator: ",").map{ String($0) }
        var sortedVal = [Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        for i in 0 ..< unsortedVal.count {
            if unsortedVal[i].description.isNumeric {
                if unsortedVal[i].contains("."){
                    if let changeVal = Double(unsortedVal[i]) {
                        sortedVal.append(changeVal)
                    }
                }
                else {
                    if let changeVal = Int(unsortedVal[i]) {
                        sortedVal.append(changeVal)
                    }
                }
            }
            else if unsortedVal[i] == "false" {
                if let changeVal = Bool(unsortedVal[i]) {
                    sortedVal.append(changeVal)
                }
                
            }
            else if unsortedVal[i] == "true" {
                if let changeVal = Bool(unsortedVal[i]) {
                    sortedVal.append(changeVal)
                }
            }
            else if (dateFormatter.date(from: unsortedVal[i]) != nil){
                if let changeVal = dateFormatter.date(from: unsortedVal[i]) {
                    sortedVal.append(changeVal)
                }
            }
            else {
                sortedVal.append(unsortedVal[i])
            }
        }
        let managedContext =
        persistentContainer.viewContext
        let entity =
        NSEntityDescription.entity(forEntityName: entity,
                                   in: managedContext)!

        let object = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        for i in 0 ..< attrArr.count {
            object.setValue(sortedVal[i], forKeyPath: String(attrArr[i]))
            print(sortedVal[i])
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func showData(option: String){
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if option == "first" {
                print(result[0])
            }
            else if option == "all" {
                for data in result as! [NSManagedObject] {
                    print(data)
                }
                
            }
            else if option == "last" {
                print(result.last!)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    public func delete(option: String, attr: String, value: AnyHashable){
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do
        {
            if option == "all" {
                try context.execute(deleteRequest)
                try context.save()
            }
            else if option == "single" {
                do {
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject] {
                        if data.value(forKey: attr) as! AnyHashable == value {
                            context.delete(data)
                        }
                    }
                    try context.save()

                    
                } catch {
                    
                    print("Failed")
                }
            }
            else {
                print("Wrong option, available option: \n 1. all")
            }
            
        }
        catch
        {
            print ("There was an error")
        }
    }
    
}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}
