//
//  ServiceManger.m
//  AVA
//
//  Created by MMADapps on 5/30/16.
//  Copyright © 2016 MMAD. All rights reserved.
//

#import "ServiceManger.h"
#import <UIKit/UIKit.h>
static ServiceManger *serviceManager = nil;

@implementation ServiceManger

+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        serviceManager = [[ServiceManger alloc]init];
    });
    return serviceManager;
}



-(void)downloadImage:(NSString *)urlString completionHandler:(void (^)(UIImage *image))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage {
     NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionTask* downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
    
    
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorMessage([error localizedDescription]);
            });
        }
    
    
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:location]];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
        }
    }];
    [downloadTask resume];
    
}

-(void)callWebService:(NSString *)urlString paramaters:(NSDictionary *)paramaters completionHandler:(void (^)(id jsonResponce))completion andErrorcompletionHandler:(void (^)(NSString *errormessage))errorMessage
{

#ifdef DEBUG
    //NSLog(@"parameters = %@",paramaters);
#endif
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:urlString];
    #ifdef DEBUG
   // NSLog(@"url:%@",url);
    #endif
    NSMutableURLRequest * checkingData;
    
    if (paramaters) {
        NSError *error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:paramaters options:kNilOptions error:&error];
        checkingData =[self request:url withData:jsonData withMethodType:@"POST"];
    } else {
        checkingData =[self request:url withData:nil withMethodType:@"GET"];

    }
    
    [[session dataTaskWithRequest:checkingData completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorMessage(error.localizedDescription);
                if (error.code == -1009 ) {

                }
                else{

                    
                }
            });
        }
        else{
            if (data != nil) {

             
                NSString *iso = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
                id result = [NSJSONSerialization JSONObjectWithData:dutf8 options:NSJSONReadingMutableContainers error:&error];
#ifdef DEBUG
                //NSLog(@"JSON RESULT : %@" , result);
#endif
       
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        errorMessage (error.localizedDescription);
                    });
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        completion(result);
                        
                    });


                }
            }
            else{
                NSError * err = [[NSError alloc]initWithDomain:@"Try again later" code:1000 userInfo:nil];
               // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorMessage (err.localizedDescription);
                });
               
            }
        }
    }] resume];
}



-(NSMutableURLRequest *)request:(NSURL *)url withData:(NSData *)JsonData withMethodType:(NSString *)Type{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:10.0];
     [request setHTTPMethod:Type];
     [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
   // [request setValue: @"Janlakshmi.MART.P423434OND-Y4sss445S-TN74558M789S-P7888L89A9S78" forHTTPHeaderField:@"APIKEY"];
   // [request setValue: @"IOS" forHTTPHeaderField:@"Os"];
   // NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"Id"];
    //[request setValue: userid forHTTPHeaderField:@"UserId"];

//    [request setValue: [[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"IMEI"];
    if ([Type isEqualToString:@"POST"]) {
        [request setHTTPBody:JsonData];
    }
    return request;
}




@end
