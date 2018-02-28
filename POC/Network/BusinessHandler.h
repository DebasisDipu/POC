//
//  BusinessHandler.h
//  Janalakshmi
//
//  Created by MMADapps on 8/29/16.
//  Copyright © 2016 MMADapps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BusinessHandler : NSObject

+(instancetype)sharedInstance;


-(void)GetServiceForPost:(NSString *)urlString completionHandler:(void (^)(NSDictionary * loginResponce))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage;


@end
