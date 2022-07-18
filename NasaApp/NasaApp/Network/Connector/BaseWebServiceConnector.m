//
//  BaseWebServiceConnector.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "BaseWebServiceConnector.h"
#import "BaseWebServiceCall.h"

@implementation BaseWebServiceConnector
@synthesize responseHandlerClassName = _ResponseHandlerClassName;

-(void) initialize:(NSDictionary*)connectorParam
{
    NSString* defaultHandlerClassName = [connectorParam objectForKey:MAPPING_HANDLER_CLASS];
    self.timeout = [[connectorParam objectForKey:MAPPING_TIMEOUT] integerValue];
    
    self.method = [connectorParam objectForKey:MAPPING_METHOD_TYPE];
    if(self.method == nil)
    {
        self.method = METHOD_GET;
    }
    
    self.serviceName = [connectorParam objectForKey:MAPPING_SERVICE_NAME];
    self.serviceNameWifi = [connectorParam objectForKey:MAPPING_SERVICE_NAME_WIFI];
    
    self.responseHandlerClassName = [connectorParam objectForKey:MAPPING_HANDLER_CLASS];
    if(_ResponseHandlerClassName == nil)
    {
        self.responseHandlerClassName = defaultHandlerClassName;
    }
    _CanLock = [[connectorParam objectForKey:MAPPING_CAN_LOCK] boolValue];
}

-(void) prepareCall:(NSDictionary*)dictionary
{
    [[self getResponseHandler] initialize];
}

-(NSObject<PWebServiceCall>*) getCall
{
    NSObject<PWebServiceCall>* call = [[BaseWebServiceCall alloc] init];
    [call setMethod:self.method];
    [call setServiceName:self.serviceName];
    [call setServiceNameWifi:self.serviceNameWifi];
    
    if([self getUrlPostString])
    {
        [call setUrlPostString:[self getUrlPostString]];
    }
    return call;
}

-(NSData*) buildBody;
{
    return [NSData data];
}

-(IWebServiceResponseHandler*) getResponseHandler;
{
    if(self.responseHandler == nil)
    {
        Class handlerClass = NSClassFromString(_ResponseHandlerClassName);
        if(handlerClass != nil)
        {
            self.responseHandler = [[handlerClass alloc] init];
            
        }
    }
    return self.responseHandler;
}

-(void)removeResponseHandler
{
    self.responseHandler=nil;
}


-(BOOL) canLock;
{
    return _CanLock;
}

-(BOOL) hasFailed;
{
    return NO;
}

-(NSInteger) getCallTimeout
{
    return self.timeout;
}

-(NSString*) getUrlPostString
{
    return @"";
}

@end
