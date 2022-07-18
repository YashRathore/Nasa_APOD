//
//  SimpleResponse.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimpleResponse : NSObject<PWebServiceResponse>
{
    BOOL _isOk;
}

@property(nonatomic,assign)BOOL isOk;

+(IWebServiceResponse*) getOkResponse;

+(IWebServiceResponse*) getKoResponse;

@end

NS_ASSUME_NONNULL_END
