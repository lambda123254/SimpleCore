import Foundation
import UIKit
import CoreData

class SimpleCore {
    var entity: String
    var classAttr = [String]()
    
    public init(entity: String) {
        self.entity = entity
    }
    
    public func insert(into: String, value: String){
        let attrArr = into.components(separatedBy: ",")
        let unsortedVal = value.split(separator: ",").map{ String($0) }
        var sortedVal = [Any]()
        for i in 0 ..< unsortedVal.count {
            if unsortedVal[i].description.isNumeric {
                if let changeVal = Int(unsortedVal[i]) {
                    sortedVal.append(changeVal)

                }
            }
            else {
                sortedVal.append(unsortedVal[i])
            }
        }
                
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }

        let managedContext =
        appDelegate.persistentContainer.viewContext
        let entity =
        NSEntityDescription.entity(forEntityName: entity,
                                   in: managedContext)!

        let object = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        for i in 0 ..< attrArr.count {
            object.setValue(sortedVal[i], forKeyPath: String(attrArr[i]))
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func showData(option: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
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
    
    public func delete(option: String){

        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            if option == "all" {
                try context.execute(deleteRequest)
                try context.save()
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
