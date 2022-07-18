//
//  IWebService.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceCall.h"
#import "IWebServiceResponse.h"
#import "IWebServiceConnector.h"

#define MAIN_URL        @"mainServiceUrl"

typedef void(^MyCompletionBlock)(BOOL success, NSError * _Nullable error,NSData * _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@protocol PWebService <NSObject>

-(NSObject<PWebServiceCall>*) newCall;
-(void) callWs:(IWebServiceConnector*)connector withResponseBlock:(MyCompletionBlock)completionBlock;
-(NSString*) getUrl:(NSString*)name;
-(void) addUrl:(NSString*)url forName:(NSString*)name;
-(void) addHeader:(NSString*)name withValue:(NSString*)value;

@end

@protocol PWebServiceDelegate <NSObject>
- (void)finishLoading;
@end


@interface IWebService:NSObject <PWebService>
{
    NSObject<PWebServiceDelegate>*  _delegate;
}
@property(nonatomic, assign) NSObject<PWebServiceDelegate>*  delegate;
@end


NS_ASSUME_NONNULL_END
