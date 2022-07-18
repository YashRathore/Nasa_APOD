//
//  APODWebService.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestWebService.h"
#import "WebServiceManager.h"

#define CONNECTOR_GET_APOD_CURRENT_MONTH   @"getapodconnector"
#define CONNECTOR_SEARCH_APOD_USER_CHOICE  @"searchapodconnector"


NS_ASSUME_NONNULL_BEGIN


@interface APODWebService : RestWebService

@property (nonatomic, assign) NSObject<WebServiceDelegate>* wsDelegate;

//+ (APODWebService*)sharedWebServiceManager;

-(void)getAPODRangingFromStartDate:(NSString*)startDate toEndDate:(NSString*)endDate;
-(void)searchAPODForDate:(NSString*)date;

-(NSDictionary*)getConfigurationParametersWithConnectorName:(NSString*)connectorName;

@end

NS_ASSUME_NONNULL_END

