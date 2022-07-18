//
//  WebServiceCallInterface.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceParameter.h"

#define METHOD_GET      @"GET"
#define METHOD_POST     @"POST"

NS_ASSUME_NONNULL_BEGIN

@protocol PWebServiceCall <NSObject>

-(NSString*) getMethod;
-(NSObject <PWebServiceCall>*) setMethod:(NSString*)method;
-(NSObject <PWebServiceCall>*) addParameter:(IWebServiceParameter*)parameter;
-(NSArray*) getParameters;
-(NSInteger) getParameterCount;
-(NSObject <PWebServiceCall>*) addHeader:(NSString*)name withValue:(NSString*)value;
-(NSDictionary*) getHeaders;

-(NSString*) getServiceName;
-(NSString*) getServiceNameWifi;
-(NSString*) getUrlPostString;
-(NSObject <PWebServiceCall>*) setServiceName:(NSString*)name;
-(NSObject <PWebServiceCall>*) setServiceNameWifi:(NSString*)name;
-(NSObject<PWebServiceCall>*) setUrlPostString:(NSString*)postString;

@end

@interface IWebServiceCall:NSObject<PWebServiceCall>
{
}
@end

NS_ASSUME_NONNULL_END
