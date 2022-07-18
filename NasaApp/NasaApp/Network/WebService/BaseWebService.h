//
//  BaseWebService.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebService.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebService : NSObject<PWebService>
{
    NSMutableDictionary* _ServerUrls;
}
@property(nonatomic, assign) NSObject<PWebServiceDelegate>*  delegate;


-(NSObject<PWebServiceCall>*) newCall;
-(void) callWs:(IWebServiceConnector*)connector  withResponseBlock:(MyCompletionBlock)completionBlock;
-(NSString*) getUrl:(NSString*)name;
-(void) addUrl:(NSString*)url forName:(NSString*)name;
-(void) addHeader:(NSString*)name withValue:(NSString*)value;

@end

NS_ASSUME_NONNULL_END
