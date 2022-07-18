//
//  GetAPODByRangeConnector.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWebServiceConnector.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetAPODByRangeConnector : BaseWebServiceConnector

@property (nonatomic, strong) NSString* startDate;
@property (nonatomic, strong) NSString* endDate;

-(void) initialize:(NSDictionary*)connectorParam;
-(void) prepareCall:(NSDictionary*)dictionary;
-(NSObject<PWebServiceCall>*) getCall;
-(NSString*) getUrlPostString;
-(BOOL) canLock;
-(NSData*) buildBody;
-(NSInteger) getCallTimeout;

@end
NS_ASSUME_NONNULL_END
