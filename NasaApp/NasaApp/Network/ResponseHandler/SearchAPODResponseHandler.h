//
//  SearchAPODResponseHandler.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceResponse.h"
#import "BaseResponseHandler.h"
#import "Macros.h"

@class APODModel;

NS_ASSUME_NONNULL_BEGIN

@interface SearchAPODResponseHandler : BaseResponseHandler

@property (nonatomic, strong) NSMutableArray*  apodArray;

-(void) initialize;

-(IWebServiceResponse*) handleInput:(NSData*)input;

-(void) fillResponse:(NSMutableDictionary*)response;

-(void) handleHeaders:(NSDictionary*) headers;

-(IWebServiceResponse*) handleHttpCode:(NSInteger)httpCode;

@end

NS_ASSUME_NONNULL_END
