//
//  BaseWebServiceCall.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "BaseWebServiceCall.h"

@implementation BaseWebServiceCall

@synthesize parameters = _parameters;
@synthesize methodProp = _method;
@synthesize headers = _headers;
@synthesize serviceNameProp = _serviceName;
@synthesize serviceNameWifiProp = _serviceNameWifi;
@synthesize postUrlString = _postUrlString;

-(id) init
{
    self = [super init];
    if(self)
    {
        _parameters = [[NSMutableArray alloc] initWithCapacity:1];
        _method = METHOD_GET;
        _headers = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

-(NSObject<PWebServiceCall>*) addParameter:(IWebServiceParameter*)parameter
{
    [_parameters addObject:parameter];
    return self;
}

-(NSArray*) getParameters
{
    return _parameters;
}

-(NSInteger) getParameterCount
{
    return [_parameters count];
}

-(NSString*) getMethod
{
    return _method;
}

-(NSObject<PWebServiceCall>*) setMethod:(NSString*)method
{
    if([method caseInsensitiveCompare:METHOD_POST] == NSOrderedSame)
    {
        self.methodProp = METHOD_POST;
    }
    else
    {
        self.methodProp = METHOD_GET;
    }
    return self;
}

-(NSObject<PWebServiceCall>*) addHeader:(NSString*)name withValue:(NSString*)value;
{
    [_headers setObject:value forKey:name];
    return self;
}

-(NSDictionary*) getHeaders
{
    return _headers;
}

-(NSString*) getServiceName
{
    return _serviceName;
}

-(NSString*) getServiceNameWifi
{
    return _serviceNameWifi;
}

-(NSString*) getUrlPostString
{
    return _postUrlString;
}

-(NSObject<PWebServiceCall>*) setServiceName:(NSString*)name
{
    self.serviceNameProp = name;
    return self;
}

-(NSObject<PWebServiceCall>*) setServiceNameWifi:(NSString*)name
{
    self.serviceNameWifiProp = name;
    return self;
}

-(NSObject<PWebServiceCall>*) setUrlPostString:(NSString*)postString
{
    self.postUrlString = postString;
    return self;
}


@end

