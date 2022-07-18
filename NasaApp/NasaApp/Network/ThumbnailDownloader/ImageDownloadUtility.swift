//
//  ImageDownloadUtility.swift
//  NasaApp
//
//  Created by Yash Rathore on 17/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit
import Foundation

class ImageDownloadUtility {
    
    public static let imageCache = ImageDownloadUtility()
    public static let placeholderImage = UIImage(systemName: "ticket")!
    
    public var urlSession = ImageURLProtocol.urlSession()
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(APODModel, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, item: APODModel, completion: @escaping (APODModel, UIImage?) -> Swift.Void) {
        
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }
        
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        // Go fetch the image.
        let urlSessionDataTask = urlSession.dataTask(with: url as URL) { (data, response, error) in
            // Check for the error, then data and try to create the image.
            guard let responseData = data, let image = UIImage(data: responseData),
                  let blocks = self.loadingResponses[url], error == nil else {
                      DispatchQueue.main.async {
                          completion(item, nil)
                      }
                      return
                  }
            
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            item.image = image
            
            let fileName = url.lastPathComponent
            if(CoreDataManager.sharedManager.saveImage(image: image, fileName: fileName ?? "test.png") == false){
                CoreDataManager.sharedManager.insertAPODModel(item)
            }
            
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                DispatchQueue.main.async {
                    block(item, image)
                }
                return
            }
        }
        urlSessionDataTask.resume()
    }
        
}

