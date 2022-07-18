//
//  IWebServiceResponseHandler.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceResponse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PWebServiceResponseHandler <NSObject>

-(void) initialize;

-(IWebServiceResponse*) handleError:(NSError*)error;
-(IWebServiceResponse*) handleInput:(NSData*)input;
-(void) handleHeaders:(NSDictionary*)headers;
-(IWebServiceResponse*) handleHttpCode:(NSInteger)httpCode;
-(void) fillResponse:(NSMutableDictionary*)response;

-(NSInteger) getErrorType;
-(void) setErrorType:(NSInteger)errorType;

-(NSInteger) getErrorSubType;
-(void) setErrorSubType:(NSInteger)errorSubType;

-(NSString*) getErrorMessage;
-(void) setErrorMessage:(NSString*)message;

@end


@interface IWebServiceResponseHandler:NSObject <PWebServiceResponseHandler>
{
}
@end

NS_ASSUME_NONNULL_END
