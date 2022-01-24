//
//  CoreData.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit

class CoreData {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        //let entityName =  NSEntityDescription.entity(forEntityName: "Image", in: context)!
        //let image = NSManagedObject(entity: entityName, insertInto: context)
        //image.setValue(data, forKeyPath: "storedImage")
        
        let newImage = Image(context: self.context)
        newImage.storedImage = data
        
        do {
            try context.save()
            print("saved image!")
            //self.images?.append(newImage)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
     func fetchImagesFromCoreData() {
     do {
     //self.images = try context.fetch(Image.fetchRequest())
         let a = try context.fetch(Image.fetchRequest())
         print(a)
     } catch {
     print("error fetching images from CoreData")
     }
     }
     
}
