//
//  CoreDataManager.swift
//  NasaApp
//
//  Created by Yash Rathore on 17/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NasaAPOD")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        
    }
    
    func save(apodModelArray:Array<APODModel>) {
        for apodModel in apodModelArray{
            CoreDataManager.sharedManager.insertAPODModel(apodModel)
        }
    }
    
    func insertAPODModel(_ model:APODModel) {
        
        let managedContext = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "APODModelEntity",
                                                in: managedContext)!
        //Yashhh
        let apodModel = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        apodModel.setValue(model.title, forKeyPath: "title")
        apodModel.setValue(model.mediaType, forKeyPath: "mediaType")
        apodModel.setValue(model.sdUrl, forKeyPath: "sdUrl")
        apodModel.setValue(model.hdUrl, forKeyPath: "hdUrl")
        apodModel.setValue(model.releaseDate, forKeyPath: "releaseDate")
        apodModel.setValue(model.pictureDetail, forKeyPath: "pictureDetail")
        apodModel.setValue(model.copyrightMessage, forKeyPath: "copyrightMessage")
        apodModel.setValue(model.serviceVersion, forKeyPath: "serviceVersion")
        apodModel.setValue(model.favourite, forKeyPath: "favourite")
        
        let fileArray = model.sdUrl?.components(separatedBy: "/")
        let fileName = fileArray?.last
        
        if(self.getSavedImage(named:fileName ?? "test.png" ) == nil){
            if let data = model.image?.jpegData(compressionQuality: 1.0) {
                apodModel.setValue(data, forKey: "image")
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error in insertAPODModel could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAPODModels()->Array<APODModel>{
        var apodModelsArray  = [APODModel]()
        let context = self.persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APODModelEntity")
            let fetchResult = try context.fetch(fetchRequest)
            guard let array = fetchResult as? [NSManagedObject] else{
                return apodModelsArray
            }
            
            for fetchedItem in array {
                var image:UIImage? = nil
                
                let fileName = fetchedItem.value(forKey: "sdUrl") as! String
                let fileArray = fileName.components(separatedBy: "/")
                let finalFileName = fileArray.last
                
                if let thumbnailImage = self.getSavedImage(named:finalFileName ?? "test.png"){
                    image = thumbnailImage
                }
                else{
                    if let data = fetchedItem.value(forKey: "image") as? Data, let thumbnail = UIImage(data: data){
                        image = thumbnail
                    }
                }
                
                
                let model = APODModel(title: fetchedItem.value(forKey: "title") as? String,
                                      mediaType: fetchedItem.value(forKey: "mediaType") as? String,
                                      sdUrl: fetchedItem.value(forKey: "sdUrl") as? String,
                                      hdUrl: fetchedItem.value(forKey: "hdUrl") as? String,
                                      releaseDate: fetchedItem.value(forKey: "releaseDate") as? String,
                                      pictureDetail: fetchedItem.value(forKey: "pictureDetail") as? String,
                                      copyrightMessage: fetchedItem.value(forKey: "copyrightMessage") as? String,
                                      serviceVersion: fetchedItem.value(forKey: "serviceVersion") as? String,
                                      favourite: fetchedItem.value(forKey: "favourite") as! Bool,
                                      image: image ?? UIImage.init())
                apodModelsArray.append(model)
            }
            return apodModelsArray
            
        } catch let error as NSError {
            print("Error in fetchAPODModels \(error)")
        }
        return apodModelsArray
    }
    
    func deleteAll(){
        
        // Delete each existing persistent store
        for store in self.persistentContainer.persistentStoreCoordinator.persistentStores {
            do{
            try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
            } catch let error as NSError {
                print("Error in deleteAll \(error)")
            }
        }

        // Re-create the persistent container
        persistentContainer = NSPersistentContainer(
            name: "NasaAPOD"
        )

        // Calling loadPersistentStores will re-create the
        // persistent stores
        persistentContainer.loadPersistentStores {
            (store, error) in
            // Handle errors
        }
    }
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveImage(image: UIImage, fileName:String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
