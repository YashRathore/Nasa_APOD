//
//  IWebServiceParameter.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PWebServiceParameter <NSObject>

-(NSString*) getName;
-(void) setName:(NSString*)name;
-(NSString*) getValue;
-(void) setValue:(NSString*)value;

@end

@interface IWebServiceParameter:NSObject <PWebServiceParameter>
{
}
@end

NS_ASSUME_NONNULL_END
