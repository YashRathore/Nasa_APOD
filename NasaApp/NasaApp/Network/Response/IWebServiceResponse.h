//
//  IWebServiceResponse.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATUS_CODE_OK                        200
#define STATUS_CODE_APOD_ACCOUNT_ERROR        201
#define STATUS_CODE_APOD__SERVER_ERROR        202
#define STATUS_CODE_NETWORK_TIMEOUT           408
#define STATUS_CODE_DATA_NOT_FOUND            777
#define STATUS_CODE_SERVICE_ERROR             500
#define STATUS_CODE_NOT_CONNECTED_TO_INTERNET 10000
#define STATUS_CODE_CANNOT_CONNECT_TO_HOST    10001
#define STATUS_CODE_UNKNOWN_ERROR             10002

//Errors types
#define ERROR_TYPE_COMMUNICATION     999
#define ERROR_TYPE_LOCK              998
#define ERROR_TYPE_INTERNAL          997
#define ERROR_TYPE_SERVICE           995
#define ERROR_TYPE_SERVER            994
#define ERROR_TYPE_ACCOUNT           993

//Errors sub-types
#define ERROR_WS_NO_CONNECTOR         10003
#define ERROR_WS_PARAMS_ERROR         10004
#define ERROR_WS_DATA_NOT_FOUND       777

NS_ASSUME_NONNULL_BEGIN

@protocol PWebServiceResponse <NSObject>

-(BOOL) isOk;

@end

@interface IWebServiceResponse:NSObject <PWebServiceResponse>
{
}

@end

NS_ASSUME_NONNULL_END
