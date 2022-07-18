//
//  BaseResponseHandler.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceResponseHandler.h"
#import "IWebServiceResponse.h"

#define TOTAL_PAGES          @"total_pages"
#define ERROR_ELEMENT        @"error"
#define ERROR_TYPE_ATTR      @"type"
#define ERROR_SUBTYPE_ATTR   @"subtype"

NS_ASSUME_NONNULL_BEGIN

@interface BaseResponseHandler : NSObject<PWebServiceResponseHandler>
{
    BOOL            _HasError;
    NSInteger       _StatusCode;
    NSInteger       _ErrorType;
    NSInteger       _ErrorSubType;
    NSString*       _ErrorMessage;
}

@property (nonatomic, assign)NSInteger statusCode;
@property (nonatomic, assign)NSInteger errorType;
@property (nonatomic, assign)NSInteger errorSubType;
@property (nonatomic, strong)NSString* errorMessage;

-(void) initialize;

-(IWebServiceResponse*) handleError:(NSError*)error;

-(IWebServiceResponse*) handleInput:(NSData*)input;

-(void) fillError:(NSMutableDictionary*)error;
-(void) fillResponse:(NSMutableDictionary*)response;

-(void) handleHeaders:(NSDictionary*) headers;

-(IWebServiceResponse*) handleHttpCode:(NSInteger)httpCode;

-(BOOL)hasFailed;

-(NSInteger) getErrorType;
-(void) setErrorType:(NSInteger)errorType;

-(NSInteger) getErrorSubType;
-(void) setErrorSubType:(NSInteger)errorSubType;

-(NSString*) getErrorMessage;
-(void) setErrorMessage:(NSString*)message;

@end

NS_ASSUME_NONNULL_END
