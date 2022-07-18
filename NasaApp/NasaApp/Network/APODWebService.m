//
//  APODWebService.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "APODWebService.h"
#import "WebServiceManager.h"
#import "Macros.h"
#import "Reachability.h"

@interface APODWebService ()

-(void) callWebService:(NSMutableDictionary*)a_Dic;

@end


@implementation APODWebService

//+ (APODWebService*)sharedWebServiceManager {
//    static APODWebService *sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedManager = [[self alloc] init];
//    });
//    return sharedManager;
//}

-(void)getAPODRangingFromStartDate:(NSString*)startDate toEndDate:(NSString*)endDate
{
    Reachability* networkStatus = [Reachability reachabilityWithHostName:HOST_ADDRESS];
    NetworkStatus netStatus = [networkStatus currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:1];
        [error setValue:[NSNumber numberWithInt:ERROR_TYPE_COMMUNICATION] forKey:RETPARAM_ERROR_TYPE];
        [error setValue:[NSNumber numberWithInteger:STATUS_CODE_NOT_CONNECTED_TO_INTERNET] forKey:RETPARAM_ERROR_SUBTYPE];
        NSMutableDictionary* respDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [respDic setValue:error forKey:RETPARAM_ERROR];
        [respDic setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
        [self.wsDelegate performSelector:@selector(webServiceResponse:) withObject:respDic afterDelay:0.1];
    }
    else{
        
#ifdef DEBUG_WS_APOD_CURRENT_MONTH
            NSMutableDictionary* respDic = [NSMutableDictionary dictionary];
        //set response parameter for debug
        /*
         { 
         //For Mock and Testing
    
         let apodModel = APODModel.init(title: "Tycho and Clavius at Dawn", mediaType: "image", sdUrl:"https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg", hdUrl: "https://apod.nasa.gov/apod/image/2207/Dawn-in-Clavius-Tycho-07-07-22.jpg", releaseDate: "2022-07-16", pictureDetail: "South is up in this dramatic telescopic view of the lunar terminator and the Moon's rugged southern highlands. The lunar landscape was captured on July 7 with the moon at its first quarter phase. The Sun shines at a low angle from the right as dawn comes to the region's young and old craters Tycho and Clavius. About 100 million years young, Tycho is the sharp-walled 85 kilometer diameter crater below and left of center. Its 2 kilometer tall central peak and far crater wall reflect bright sunlight, Its smooth floor lies in dark shadow. Debris ejected during the impact that created Tycho make it the stand out lunar crater when the Moon is near full though. They produce a highly visible radiating system of light streaks or rays that extend across much of the lunar near side. In fact, some of the material collected at the Apollo 17 landing site, about 2,000 kilometers away, likely originated from the Tycho impact.  One of the oldest and largest craters on the Moon's near side, 225 kilometer diameter Clavius is due south (above) of Tycho. Clavius crater's own ray system resulting from its original impact event would have faded long ago. The old crater's worn walls and smooth floor are now overlayed by newer smaller craters from impacts that occurred after Clavius was formed. Reaching above the older crater, tops of the newer crater walls reflect this dawn's early light to create narrow shining arcs within a shadowed Clavius.", copyrightMessage: "Eduardo\nSchaberger Poupeau", serviceVersion: "v1", favourite: false, image: UIImage.init())
         
         }
         */
            [self.wsDelegate performSelector:@selector(webServiceResponse:) withObject:respDic afterDelay:0.1];
#else
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            //call webservice using request parameter
            [dic setValue:@"" forKey:MAPPING_APIKEY_PARAMETER];
            [dic setValue:CONNECTOR_GET_APOD_CURRENT_MONTH forKey:MAPPING_CONNECTOR_NAME];
            [dic setValue:startDate forKey:MAPPING_START_DATE_PARAMETER];
            [dic setValue:endDate forKey:MAPPING_END_DATE_PARAMETER];
            [NSThread detachNewThreadSelector:@selector(callWebService:) toTarget:self withObject:dic];
#endif
    }
}


-(void)searchAPODForDate:(NSString*)date{
    
    Reachability* networkStatus = [Reachability reachabilityWithHostName:HOST_ADDRESS];
    NetworkStatus netStatus = [networkStatus currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:1];
        [error setValue:[NSNumber numberWithInt:ERROR_TYPE_COMMUNICATION] forKey:RETPARAM_ERROR_TYPE];
        [error setValue:[NSNumber numberWithInteger:STATUS_CODE_NOT_CONNECTED_TO_INTERNET] forKey:RETPARAM_ERROR_SUBTYPE];
        NSMutableDictionary* respDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [respDic setValue:error forKey:RETPARAM_ERROR];
        [respDic setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
        [self.wsDelegate performSelector:@selector(webServiceResponse:) withObject:respDic afterDelay:0.1];
    }
    else{
        if(date != nil && date.length>0)
        {
#ifdef DEBUG_WS_GET_APOD
            NSMutableDictionary* respDic = [NSMutableDictionary dictionary];
            //set response parameter for debug
            /*
             { 
             //For Mock and Testing
        
             let apodModel = APODModel.init(title: "Tycho and Clavius at Dawn", mediaType: "image", sdUrl:"https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg", hdUrl: "https://apod.nasa.gov/apod/image/2207/Dawn-in-Clavius-Tycho-07-07-22.jpg", releaseDate: "2022-07-16", pictureDetail: "South is up in this dramatic telescopic view of the lunar terminator and the Moon's rugged southern highlands. The lunar landscape was captured on July 7 with the moon at its first quarter phase. The Sun shines at a low angle from the right as dawn comes to the region's young and old craters Tycho and Clavius. About 100 million years young, Tycho is the sharp-walled 85 kilometer diameter crater below and left of center. Its 2 kilometer tall central peak and far crater wall reflect bright sunlight, Its smooth floor lies in dark shadow. Debris ejected during the impact that created Tycho make it the stand out lunar crater when the Moon is near full though. They produce a highly visible radiating system of light streaks or rays that extend across much of the lunar near side. In fact, some of the material collected at the Apollo 17 landing site, about 2,000 kilometers away, likely originated from the Tycho impact.  One of the oldest and largest craters on the Moon's near side, 225 kilometer diameter Clavius is due south (above) of Tycho. Clavius crater's own ray system resulting from its original impact event would have faded long ago. The old crater's worn walls and smooth floor are now overlayed by newer smaller craters from impacts that occurred after Clavius was formed. Reaching above the older crater, tops of the newer crater walls reflect this dawn's early light to create narrow shining arcs within a shadowed Clavius.", copyrightMessage: "Eduardo\nSchaberger Poupeau", serviceVersion: "v1", favourite: false, image: UIImage.init())
             
             }
             */
            [self.wsDelegate performSelector:@selector(webServiceResponse:) withObject:respDic afterDelay:0.1];
#else
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            //call webservice using request parameter
            [dic setValue:@"" forKey:MAPPING_APIKEY_PARAMETER];
            [dic setValue:CONNECTOR_SEARCH_APOD_USER_CHOICE forKey:MAPPING_CONNECTOR_NAME];
            [dic setValue:date forKey:MAPPING_DATE_PARAMETER];
            [NSThread detachNewThreadSelector:@selector(callWebService:) toTarget:self withObject:dic];
#endif
        }
        else{
            NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:1];
            [error setValue:[NSNumber numberWithInt:ERROR_TYPE_INTERNAL] forKey:RETPARAM_ERROR_TYPE];
            [error setValue:[NSNumber numberWithInt:ERROR_WS_PARAMS_ERROR] forKey:RETPARAM_ERROR_SUBTYPE];
            NSMutableDictionary* respDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [respDic setValue:error forKey:RETPARAM_ERROR];
            [respDic setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
            [self.wsDelegate performSelector:@selector(webServiceResponse:) withObject:respDic afterDelay:0.1];
        }
    }
}

#pragma mark - callWebService

- (void)callWebService:(NSMutableDictionary*)parameterDict
{
    NSDictionary* configParams = [self getConfigurationParametersWithConnectorName:[parameterDict valueForKey:MAPPING_CONNECTOR_NAME]];
    
    WebServiceManager* wsManager = [[WebServiceManager alloc]initwithConfiguration:configParams withInputParameters:parameterDict];
    [wsManager treatCall:parameterDict withDelegate:self.wsDelegate];
}

-(NSDictionary*)getConfigurationParametersWithConnectorName:(NSString*)connectorName{
    NSMutableDictionary* configParams = [NSMutableDictionary dictionary];
    [configParams setObject:@"3" forKey:MAPPING_MAX_ATTEMPTS];
    [configParams setObject:@"120" forKey:MAPPING_FREEZE_DURATION];
    [configParams setObject:HOST_ADDRESS forKey:MAPPING_URL];
    [configParams setObject:@"30" forKey:MAPPING_TIMEOUT];
    [configParams setObject:[NSNumber numberWithBool:NO] forKey:MAPPING_CAN_LOCK];
    [configParams setObject:METHOD_GET forKey:MAPPING_METHOD_TYPE];
    
    if ([connectorName isEqualToString:CONNECTOR_GET_APOD_CURRENT_MONTH]) {
        [configParams setObject:@"GetAPODByRangeResponseHandler" forKey:MAPPING_HANDLER_CLASS];
        [configParams setObject:@"GetAPODByRangeConnector" forKey:MAPPING_CONNECTOR_CLASS];
        [configParams setObject:@"BaseResponseHandler" forKey:MAPPING_DEFAULT_HANDLER_CLASS];
    }
    else if ([connectorName isEqualToString:CONNECTOR_SEARCH_APOD_USER_CHOICE]){
        [configParams setObject:@"SearchAPODResponseHandler" forKey:MAPPING_HANDLER_CLASS];
        [configParams setObject:@"SearchAPODConnector" forKey:MAPPING_CONNECTOR_CLASS];
        [configParams setObject:@"BaseResponseHandler" forKey:MAPPING_DEFAULT_HANDLER_CLASS];
    }
    
    [configParams setObject:@"APODWebService" forKey:MAPPING_WEB_SERVICE_CLASS];
    [configParams setObject:@"serviceUrl" forKey:MAPPING_SERVICE_NAME];
    [configParams setObject:@"serviceUrlWifi" forKey:MAPPING_SERVICE_NAME_WIFI];

    return configParams;
}

@end
