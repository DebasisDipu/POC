//
//  BusinessHandler.m
//  Janalakshmi
//
//  Created by MMADapps on 8/29/16.
//  Copyright © 2016 MMADapps. All rights reserved.
//

#import "BusinessHandler.h"
#import "ServiceManger.h"
//#import "EHPlainAlert.h"



static BusinessHandler *businessHandler = nil;
@implementation BusinessHandler

+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        businessHandler = [[BusinessHandler alloc]init];
    });
    return businessHandler;
}



-(void)GetServiceForPost:(NSString *)urlString completionHandler:(void (^)(NSDictionary * loginResponce))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage {
    
    
    
    
    NSString * url =urlString;// [NSString stringWithFormat:@"%@&userId=%@&limit=%@&skip=%@&access_token=%@&ltDate=%@",urlString,searchText,UserId,limit,skip,accessToken,ltdate];
    
    
    
    [[ServiceManger sharedInstance] callWebService:url paramaters:nil completionHandler:^(id jsonResponce) {
        
        NSDictionary * resoponceObject;
        if (![jsonResponce isKindOfClass:[NSNull class]])
        {
            resoponceObject = (NSDictionary * )jsonResponce;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(resoponceObject);
            });
        }
        else{
            NSString * err = @"TRYAGINLATTER ";
            dispatch_async(dispatch_get_main_queue(), ^{
                errorMessage(err);
            });
        }
        
        
    } andErrorcompletionHandler:^(NSString *errormessage) {
        
        NSString * err = errormessage;
        dispatch_async(dispatch_get_main_queue(), ^{
            errorMessage(err);
        });
    }];
    
}


@end
