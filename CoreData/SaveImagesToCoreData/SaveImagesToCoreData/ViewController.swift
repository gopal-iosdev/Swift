//
//  ViewController.swift
//  SaveImagesToCoreData
//
//  Created by Gopal Gurram on 2/9/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext! = nil
    var entity: NSEntityDescription! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedObjectContext)!
        
        saveDataToCoreData()
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }

    private func saveDataToCoreData() {
        let image = UIImage(named: "Placeholder")
        let imageData = image?.pngData()
        
        managedObjectContext.perform {
            let imageObject = NSManagedObject(entity: self.entity, insertInto: self.managedObjectContext)
            imageObject.setValue(imageData, forKey: Constants.imageAttribute)
            
            self.saveContext()
        }
    }
    
    private func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

