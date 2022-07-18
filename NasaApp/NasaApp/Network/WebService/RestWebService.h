//
//  RestWebService.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWebService.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestWebService : BaseWebService
{
    
@private
    NSMutableDictionary*    _headers;
    IWebServiceConnector*           _connector;
    NSObject<PWebServiceCall>*      _call;

    NSURLResponse*          _response;
    NSMutableData*          _responseData;
    NSTimer*                _connectionTimeout;
}
@property(nonatomic, strong) IWebServiceConnector*      connector;
@property(nonatomic, strong) NSObject<PWebServiceCall>* call;
@property(nonatomic, strong) NSURLResponse*     response;
@property(nonatomic, strong) NSData*     responseData;
@property(nonatomic, strong) NSTimer*    connectionTimeout;


-(void) callWs:(IWebServiceConnector*)connector withResponseBlock:(MyCompletionBlock)completionBlock;

-(NSString*) buildUrl:(NSObject<PWebServiceCall>*)call;

-(void) addHeader:(NSString*)name withValue:(NSString*)value;

@end


NS_ASSUME_NONNULL_END
