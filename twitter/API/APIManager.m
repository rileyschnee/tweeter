//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"BrmXFeq9aOEM2gHVO2JesM9yL"; // Enter your consumer key here
static NSString * const consumerSecret = @"fKPAVaZvb0oixWAMDy9aZ6cR03meQC8uFJeROncFQQO9OAPbd1"; // Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       // Cache it
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];

       if (completion) { completion(tweetDictionaries, nil); }
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if (completion) { completion(nil, error); }
   }];
}

@end