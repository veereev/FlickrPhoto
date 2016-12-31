//
//  FlickrAPI.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 25/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import Foundation

enum Method: String{
    
    case interestingPhotos = "flickr.interestingness.getList"
    
}
enum FlickrError : Error{
    case invalidJSONData
}
struct FlickrAPI
{
    
   private static let baseURLString = "https://api.flickr.com/services/rest"
 
   private static let apikey = "51e49230267d85f72ee4a449fa371dcd"
 
    private static let dateFormatter : DateFormatter = {
    
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        
        return formatter
    
    }()
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL
    {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
        
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : apikey
        
        ]
        
        for (key,value) in baseParams
        {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let params = parameters {
            
            for (key,value) in params{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            components.queryItems = queryItems
            
        }
        return components.url!
    }
    
    static var interestingPhotosURL : URL{
        
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_h,date_taken"])
        
    }
    static func photos(fromJSON data:Data) -> PhotosResult
    {
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            
            guard let jsonDictionary = jsonObject as? [AnyHashable:Any],
            let photos = jsonDictionary["photos"] as? [String:Any],
            let photosArray = photos["photo"] as? [[String:Any]]
            else {
                print("Unsuccessful parsing in the begining")
                return .failure(FlickrError.invalidJSONData)}
            
            
            var finalPhotos = [Photo]()
            
            for photoJson in photosArray
            {
                if let photo = photo(fromJSON: photoJson)
                {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.isEmpty && !photosArray.isEmpty
            {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        }
        catch let error{
            return .failure(error)
        }
    }
    private static func photo(fromJSON json:[String:Any]) -> Photo?
    {
        guard let photoID = json["id"] as? String,
              let title = json["title"] as? String,
              let dateString = json["datetaken"] as? String,
              let photoURLString = json["url_h"] as? String,
              let url = URL(string: photoURLString),
              let dateTaken = dateFormatter.date(from: dateString)
        
            
            else { return nil  }
        return Photo(title: title, remoteURL: url, photoID: photoID, dateTaken: dateTaken)
    }
}
