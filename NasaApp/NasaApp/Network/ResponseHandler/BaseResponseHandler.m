//
//  BaseResponseHandler.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "BaseResponseHandler.h"
#import "SimpleResponse.h"
#import "WebServiceManager.h"

@implementation BaseResponseHandler

@synthesize statusCode = _StatusCode;
@synthesize errorType = _ErrorType;
@synthesize errorSubType = _ErrorSubType;
@synthesize errorMessage = _ErrorMessage;

-(void) initialize;
{
    _HasError        = NO;
    _ErrorType        = -1;
    _ErrorMessage    = nil;
    _StatusCode     = STATUS_CODE_OK;
}

-(IWebServiceResponse*) handleError:(NSError*)error
{
    SimpleResponse* response = nil;
    
    if(error.domain == NSURLErrorDomain)
    {
        switch (error.code)
        {
           /* case NSURLErrorTimedOut:
            {
                response = [[SimpleResponse alloc] init];
                response.isOk = NO;
                _StatusCode = STATUS_CODE_NETWORK_TIMEOUT;
            }
                break;*/
            default:
                response = [[SimpleResponse alloc] init];
                response.isOk = NO;
                _StatusCode = STATUS_CODE_UNKNOWN_ERROR;
                break;
        }
    }
    
    return (IWebServiceResponse*) response;
}

-(IWebServiceResponse*) handleInput:(NSData*)input
{
    IWebServiceResponse* response = nil;
    
    if(input == nil)
    {
        response = [SimpleResponse getKoResponse];
    }
    else
    {
        NSError* error;
        NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:input options:0 error:&error];

        int totalPages = [parsedData[TOTAL_PAGES] intValue];

        if (totalPages>0)
        {
            response = [SimpleResponse getOkResponse];
        }
        else
        {
             response = [SimpleResponse getKoResponse];
        }
    }
    
    return response;
}

-(void) handleHeaders:(NSDictionary*) headers
{
    //Currently nothing to do
}

-(IWebServiceResponse*) handleHttpCode:(NSInteger)httpCode
{
    if(STATUS_CODE_OK != httpCode || STATUS_CODE_OK != _StatusCode)
    {
        if(STATUS_CODE_OK == _StatusCode)
        {
            _StatusCode = httpCode;
        }
    }
    return nil;
}

-(void) fillError:(NSMutableDictionary*)error
{
    if(_HasError)
    {
        int retparam_error_type = -1;
        switch (_ErrorType) {
            case STATUS_CODE_APOD_ACCOUNT_ERROR:
                retparam_error_type = ERROR_TYPE_ACCOUNT;
                break;
                
            case STATUS_CODE_APOD__SERVER_ERROR:
                retparam_error_type = ERROR_TYPE_SERVER;
                break;
                
            default:
                retparam_error_type = (int)_ErrorType;
                break;
        }
        
        [error setValue:[NSNumber numberWithInt:retparam_error_type] forKey:RETPARAM_ERROR_TYPE];
        [error setValue:[NSNumber numberWithInteger:_ErrorSubType] forKey:RETPARAM_ERROR_SUBTYPE];
        if(_ErrorMessage)
        {
            [error setValue:_ErrorMessage forKey:RETPARAM_ERROR_MESSAGE];
        }
    }
}

-(void) fillResponse:(NSMutableDictionary*)response
{
    switch(_StatusCode)
    {
        case STATUS_CODE_OK:
        {
            NSMutableDictionary* error = [[NSMutableDictionary alloc] initWithCapacity:3];
            [self fillError:error];
            [response setValue:error forKey:RETPARAM_ERROR];
        }
            break;
        case STATUS_CODE_DATA_NOT_FOUND:
        case STATUS_CODE_NOT_CONNECTED_TO_INTERNET:
        case STATUS_CODE_NETWORK_TIMEOUT:
        case STATUS_CODE_CANNOT_CONNECT_TO_HOST:
        {
            NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:2];
            [error setValue:[NSNumber numberWithInt:ERROR_TYPE_COMMUNICATION] forKey:RETPARAM_ERROR_TYPE];
            [error setValue:[NSNumber numberWithInteger:_StatusCode] forKey:RETPARAM_ERROR_SUBTYPE];
            [response setValue:error forKey:RETPARAM_ERROR];
            [response setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
        }
            break;
        default:
        {
            NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:2];
            [error setValue:[NSNumber numberWithInt:ERROR_TYPE_INTERNAL] forKey:RETPARAM_ERROR_TYPE];
            [error setValue:[NSNumber numberWithInteger:_StatusCode] forKey:RETPARAM_ERROR_SUBTYPE];
            [response setValue:error forKey:RETPARAM_ERROR];
            [response setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
        }
            break;
    }
}

-(BOOL)hasFailed
{
    return _HasError;
}

-(NSInteger) getErrorType
{
    return _ErrorType;
}

-(void) setErrorType:(NSInteger)errorType
{
    _ErrorType = errorType;
}

-(NSInteger) getErrorSubType
{
    return _ErrorSubType;
}

-(void) setErrorSubType:(NSInteger)errorSubType
{
    _ErrorSubType = errorSubType;
}

-(NSString*) getErrorMessage
{
    return _ErrorMessage;
}

-(void) setErrorMessage:(NSString*)message
{

}

@end
