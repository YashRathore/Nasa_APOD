//
//  BaseWebServiceCall.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebServiceCall : NSObject<PWebServiceCall>
{
    
@private
    NSMutableArray*         _parameters;
    NSString*               _method;
    NSMutableDictionary*    _headers;
    NSString*               _serviceName;
    NSString*               _serviceNameWifi;
    NSString*               _postUrlString;
}

@property (nonatomic, strong) NSMutableArray*       parameters;
@property (nonatomic, strong) NSString*             methodProp;
@property (nonatomic, strong) NSMutableDictionary*  headers;
@property (nonatomic, strong) NSString*             serviceNameProp;
@property (nonatomic, strong) NSString*             serviceNameWifiProp;
@property (nonatomic, strong) NSString*             postUrlString;


-(NSObject<PWebServiceCall>*) addParameter:(IWebServiceParameter*)parameter;

-(NSArray*) getParameters;

-(NSInteger) getParameterCount;

-(NSString*) getMethod;

-(NSObject<PWebServiceCall>*) setMethod:(NSString*)method;

-(NSObject<PWebServiceCall>*) addHeader:(NSString*)name withValue:(NSString*)value;

-(NSDictionary*) getHeaders;

-(NSString*) getServiceName;

-(NSString*) getServiceNameWifi;

-(NSString*) getUrlPostString;

-(NSObject<PWebServiceCall>*) setServiceName:(NSString*)name;

-(NSObject<PWebServiceCall>*) setServiceNameWifi:(NSString*)name;

-(NSObject<PWebServiceCall>*) setUrlPostString:(NSString*)postString;

@end

NS_ASSUME_NONNULL_END
