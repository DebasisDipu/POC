//
//  ServiceManger.h
//  AVA
//
//  Created by MMADapps on 5/30/16.
//  Copyright © 2016 MMAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServiceManger : NSObject

+(instancetype)sharedInstance;
-(void)callWebService:(NSString *)urlString paramaters:(NSDictionary *)paramaters completionHandler:(void (^)(id jsonResponce))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage;

-(void)downloadImage:(NSString *)urlString completionHandler:(void (^)(UIImage *image))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage;



@end
