//
//  IWebServiceConnector.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceCall.h"
#import "IWebServiceResponseHandler.h"

#define    MAPPING_START_DATE_PARAMETER    @"start_date"
#define    MAPPING_END_DATE_PARAMETER      @"end_date"
#define    MAPPING_DATE_PARAMETER          @"date"
#define    MAPPING_APIKEY_PARAMETER        @"apikey"
#define    MAPPING_CONNECTOR_NAME          @"connectorName"
#define    MAPPING_METHOD_TYPE             @"method"
#define    MAPPING_TIMEOUT                 @"timeout"
#define    MAPPING_HANDLER_CLASS           @"handler"
#define    MAPPING_CONNECTOR_CLASS         @"connectorclass"
#define    MAPPING_WEB_SERVICE_CLASS       @"webserviceclass"
#define    MAPPING_DEFAULT_HANDLER_CLASS   @"defaulthandler"
#define    MAPPING_URL                     @"serviceUrl"
#define    MAPPING_URL_WIFI                @"serviceUrlWifi"
#define    MAPPING_SERVICE_NAME            @"servicename"
#define    MAPPING_SERVICE_NAME_WIFI       @"servicenamewifi"
#define    MAPPING_CAN_LOCK                @"canLock"
#define    MAPPING_FREEZE_DURATION         @"FreezeDurationAfterLock"
#define    MAPPING_MAX_ATTEMPTS            @"MaxUnsuccessfulAttemps"

NS_ASSUME_NONNULL_BEGIN

@protocol PWebServiceConnector <NSObject>

-(NSObject<PWebServiceCall>*) getCall;
-(NSData*) buildBody;
-(IWebServiceResponseHandler*) getResponseHandler;
-(void)removeResponseHandler;
-(void) initialize:(NSDictionary*)connectorParam;
-(void) prepareCall:(NSDictionary*)dictionary;
-(BOOL) canLock;
-(BOOL) hasFailed;

-(NSInteger) getCallTimeout;

@end

@interface IWebServiceConnector:NSObject<PWebServiceConnector>
{
}

@end

NS_ASSUME_NONNULL_END

