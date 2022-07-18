//
//  BaseWebServiceConnector.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceConnector.h"
#import "IWebServiceResponseHandler.h"
#import "IWebServiceCall.h"

NS_ASSUME_NONNULL_BEGIN


@interface BaseWebServiceConnector : NSObject<PWebServiceConnector>
{
@private
    BOOL                    _CanLock;
    NSString*               _ResponseHandlerClassName;
}

@property (nonatomic, assign) NSInteger             timeout;
@property (nonatomic, strong) NSString*             method;
@property (nonatomic, strong) NSString*             serviceName;
@property (nonatomic, strong) NSString*             serviceNameWifi;
@property (nonatomic, strong) NSString*             postUrlString;
@property (nonatomic, strong, nullable) IWebServiceResponseHandler*   responseHandler;
@property (nonatomic, strong) NSString*             responseHandlerClassName;

-(NSObject<PWebServiceCall>*) getCall;
-(NSData*) buildBody;
-(IWebServiceResponseHandler*) getResponseHandler;
-(void)removeResponseHandler;

-(void) initialize:(NSDictionary*)connectorParam;
-(void) prepareCall:(NSDictionary*)dictionary;
-(BOOL) canLock;
-(BOOL) hasFailed;
-(NSInteger) getCallTimeout;
-(NSString*) getUrlPostString;

@end


NS_ASSUME_NONNULL_END
