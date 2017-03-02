//
//  ViewController.swift
//  CoreDataTutorial
//
//  Created by James Rochabrun on 3/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import CoreData

class PhotoVC: UITableViewController {
    
    private let cellID = "cellID"
    
    //1 create photo array
    var photoArray: [Photo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos Feed"
        view.backgroundColor = .white
        tableView.register(PhotoCell.self, forCellReuseIdentifier: cellID)

//        clearData()
//        getDataFromAPI { (photos) in
//            self.photoArray = photos
//            self.tableView.reloadData()
//        }
        
        //good starting point check it with new uncoupled methods
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PhotoCell
        
        if let photo = photoArray?[indexPath.row]  {
            cell.setPhotoCellWith(photo: photo)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = photoArray?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 80
    }
    
    //CREATE
    func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            photoEntity.author = dictionary["author"] as? String
            photoEntity.tags = dictionary["tags"] as? String
            let mediaDictionary = dictionary["media"] as? [String: AnyObject]
            photoEntity.mediaURL = mediaDictionary?["m"] as? String
            return photoEntity
        }
        return nil
    }
    
    //SAVE
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
        CoreDataStack.sharedInstance.saveContext()
    }
    
    //FETCH
    func fetchdataFromCoredata() -> [Photo]? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let photoArray = try context.fetch(fetchRequest) as? [Photo]
            return photoArray
        } catch let error {
            print("ERROR FETHCING FROM CONTEXT : \(error)")
        }
        return nil
    }
    
    //DELETE
    func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}


extension PhotoVC {
    
    func getDataFromAPI(completion: @escaping ([[String: AnyObject]]) -> ()) {
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=soccer&nojsoncallback=1#"
        
        guard let url = URL(string: urlString) else {
            print("ERROR IN URL STRUCTURE")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("ERROR FETCHING JSON: ", error ?? "error")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemJsonArray = json["items"] as? [[String: AnyObject]] else {
                        print("ERROR IN JSON STRUCTURE FROM THE SERVER")
                        return
                    }
                    DispatchQueue.main.async {
                        completion(itemJsonArray)
                    }
                }
            } catch let error {
                print("SERIALIZATION ERROR PROBABLY DATA STRUCTURE FROM SERVER:" , error)
            }
            }.resume()
    }
}











