//
//  ImageURLProtocol.swift
//  NasaApp
//
//  Created by Yash Rathore on 17/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit

class ImageURLProtocol: URLProtocol {

    var cancelledOrComplete: Bool = false
    var block: DispatchWorkItem!
    
    private static let queue = OS_dispatch_queue_serial(label: "com.apple.imageLoaderURLProtocol")
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    class override func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return false
    }
    
    final override func startLoading() {
        guard let urlClient = client else {
            return
        }
        
        block = DispatchWorkItem(block: {
            if self.cancelledOrComplete == false {
                //Test mock data
//                    urlClient.urlProtocol(self, didLoad: data)
                    urlClient.urlProtocolDidFinishLoading(self)
                }
            self.cancelledOrComplete = true
        })
        
        ImageURLProtocol.queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 50 * NSEC_PER_MSEC), execute: block)
    }
    
    final override func stopLoading() {
        ImageURLProtocol.queue.async {
            if self.cancelledOrComplete == false, let cancelBlock = self.block {
                cancelBlock.cancel()
                self.cancelledOrComplete = true
            }
        }
    }
    
    static func urlSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
//        config.protocolClasses = [ImageURLProtocol.self]
        return  URLSession(configuration: config)
    }
}

//Incase we use shared url session
/*
 You don’t provide a delegate or a configuration object.
 You can’t obtain data incrementally as it arrives from the server.
 You can’t significantly customize the default connection behavior.
 Your ability to perform authentication is limited.
 You can’t perform background downloads or uploads when your app isn’t running.
 */
