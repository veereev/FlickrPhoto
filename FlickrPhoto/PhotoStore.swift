//
//  PhotoStore.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 25/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import UIKit
import  CoreData

enum PhotosResult{
    case success([Photo])
    case failure(Error)
}

enum ImageResult{
    case success(UIImage)
    case failure(Error)
}
enum PhotoCreationError: Error{
    case imageCreationError
}
class PhotoStore
{
    let imageStore = ImageStore()
    
    let persistentContainer : NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "FlickrPhoto")
    
        container.loadPersistentStores(completionHandler: {
        
            (description,error) -> Void in
            
            if let error = error{
                print("Error setting up core data: \(error)")
            }
        
        })
     return container
    }()
    
    
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)

    }()
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult
    {
        guard let jsonData = data else
        {
          return .failure(error!)
        }
     return FlickrAPI.photos(fromJSON: jsonData)
    }
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void)
    {
       guard let photoKey = photo.photoID else
       {
        preconditionFailure("Photo expected to have a photo ID")
        }
        
        if let image = imageStore.image(forKey: photoKey)
        {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        
       guard let photoURL = photo.remoteURL else
       {
        preconditionFailure("Photo expected to have a photo url")
        }
        let request = URLRequest(url: photoURL as URL)
        let task = session.dataTask(with: request, completionHandler: {
        
            (data, response, error ) -> Void in
            
             let result = self.processImageData(data: data, error: error)
            
            if case let .success(image) = result{
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        })
        
        task.resume()
        
        
    }
    private func processImageData(data: Data?, error: Error?) -> ImageResult
    {
        guard let imageData = data,
              let image = UIImage(data: imageData)
        else {
        
            if data == nil
            {
                return .failure(error!)
            }
            else
            {
                return .failure(PhotoCreationError.imageCreationError)
            }
        
        }
        
        return .success(image)
    }
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void)
    {
        let url = FlickrAPI.interestingPhotosURL
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
        
            (data, response, error) -> Void in
            
 
            let result = self.processPhotosRequest(data: data, error: error)
            
            OperationQueue.main.addOperation {
               completion(result)
            }
            
        
        })
        task.resume()
    }
}
