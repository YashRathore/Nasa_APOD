//
//  RestWebService.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "RestWebService.h"
#import "SimpleResponse.h"
#import "WebServiceManager.h"
#import "Macros.h"

@interface RestWebService ()
{
    NSMutableDictionary *onlyOneRequestForSameEndPointIsFiredDictionary;
}

- (IWebServiceResponse*)treatResponse;
- (void)treatError:(NSError*)error;
@end


@implementation RestWebService

@synthesize connector = _connector;
@synthesize call = _call;
@synthesize response = _response;
@synthesize responseData = _responseData;
@synthesize connectionTimeout = _connectionTimeout;

-(id) init
{
    self = [super init];
    if(self)
    {
        //if required
        //_headers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//If we need synchronous and asynchronous mode connections
//#ifdef _ASYNC_MODE
-(void) callWs:(IWebServiceConnector*)connector withResponseBlock:(MyCompletionBlock)completionBlock
{
    if (completionBlock == nil) {
        return;
    }
    
    if (onlyOneRequestForSameEndPointIsFiredDictionary == nil) {
        onlyOneRequestForSameEndPointIsFiredDictionary = [NSMutableDictionary new];
    }

    self.connector = connector;
    self.call = [connector getCall];
    __block NSString* url = [self buildUrl:self.call];
    
    if ([onlyOneRequestForSameEndPointIsFiredDictionary.allKeys containsObject:url])
    {
        NSMutableArray *completionHandlersArray = [onlyOneRequestForSameEndPointIsFiredDictionary objectForKey:url];
        [completionHandlersArray addObject:completionBlock];
        [onlyOneRequestForSameEndPointIsFiredDictionary setObject:completionHandlersArray forKey:url];
    } else {
        [onlyOneRequestForSameEndPointIsFiredDictionary setObject:[NSArray arrayWithObjects:completionBlock, nil] forKey:url];
    }
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    
    /*
    //If need to add headers
    [_headers removeAllObjects];
    [_headers addEntriesFromDictionary:[self.call getHeaders]];
    */
    
    /*
     //If we require post method
    NSData* inData = nil;
    [request setAllHTTPHeaderFields:_headers];
    
    if([METHOD_POST caseInsensitiveCompare:[self.call getMethod]] == NSOrderedSame)
    {
        inData = [connector buildBody];
        [request setHTTPBody:inData];
        
        [request setHTTPMethod:@"POST"];
    }*/
    
    if([connector getCallTimeout] > 0)
    {
        [request setTimeoutInterval:([connector getCallTimeout])];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        BOOL result = NO;
        if (error == nil) {
            if (data != nil) {
                result = YES;
                self.response = response;
                self.responseData = data;
                SimpleResponse* simpleResponse = (SimpleResponse*)[self treatResponse];
                if(!simpleResponse.isOk){
                    result = NO;
                    
                    error = [NSError errorWithDomain:APP_ERROR_DOMIAN code:DATA_NOT_FOUND userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Empty data in response",NSLocalizedDescriptionKey, nil]];
                    
                    [self treatError:error];
                }
            } else {
                self.response = response;
                self.responseData = data;
                result = NO;
                
                error = [NSError errorWithDomain:APP_ERROR_DOMIAN code:DATA_NOT_FOUND userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Empty data in response",NSLocalizedDescriptionKey, nil]];
                
                [self treatError:error];
            }
        } else {
            result = NO;
            self.response = response;
            self.responseData = data;
            [self treatError:error];
        }
        NSArray *handlersArray = [self->onlyOneRequestForSameEndPointIsFiredDictionary objectForKey:url];
        if (handlersArray && handlersArray.count>0) {
            for (MyCompletionBlock myCompletionBlock in handlersArray)
            {
                myCompletionBlock(result,error,data);
            }
        }
    }];
    
    [task resume];
}

/*
 timeout handling
-(void) customTimeout
{
    NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil];
    [self treatError:error];
}
 */

- (IWebServiceResponse*)treatResponse
{
//    [self.connectionTimeout invalidate];
    
    IWebServiceResponseHandler* handler = [self.connector getResponseHandler];
//    [handler handleHeaders:[(NSHTTPURLResponse*)self.response allHeaderFields]];

    IWebServiceResponse* resp;
    resp = [handler handleHttpCode:[(NSHTTPURLResponse*)self.response statusCode]];
    
    if(resp == nil)
    {
        resp = [handler handleInput:self.responseData];
    }
    
    [self.delegate finishLoading];
    
    return resp;
}

- (void)treatError:(NSError*)error
{
    [self.connectionTimeout invalidate];
    
    IWebServiceResponseHandler* handler = [self.connector getResponseHandler];
    [handler handleError:error];
    [self.delegate finishLoading];
}
/*
#else

//SYNC MODE

#endif
 */

-(NSString*) buildUrl:(NSObject<PWebServiceCall>*)call
{
    NSMutableString* url = [NSMutableString stringWithCapacity:10];
    
    NSString* serviceName = nil;
  /*
   // if outside wifi or outside network different url configuration to be loaded
    {
        //Try to retrieve the Wifi url
        serviceName = [call getServiceNameWifi];
    }
   */
    
    //If url empty
    if(serviceName == nil || [serviceName length] == 0)
    {
        //Retrieve the default url
        serviceName = [call getServiceName];
    }
    
    if([call getUrlPostString])
    {
        [url appendString:[self getUrl:serviceName]];
        [url appendString:[call getUrlPostString]];
    }
    else
    {
        [url appendString:[self getUrl:serviceName]];
    }
    
    if(([METHOD_GET caseInsensitiveCompare:[call getMethod]] == NSOrderedSame))
    {
        /*
        NSMutableString* parameters = [NSMutableString stringWithCapacity:10];
        BOOL first = YES;
        for(IWebServiceParameter* param in [call getParameters])
        {
            if(first)
            {
                first = NO;
            }
            else
            {
                [parameters appendString:@"&"];
            }
            [parameters appendString:[param getName]];
            [parameters appendString:@"="];
            [parameters appendString:[param getValue]];
        }
        */
    }
    return url;
}


-(void) addHeader:(NSString*)name withValue:(NSString*)value;
{
    [_headers setObject:value forKey:name];
}

@end
