//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"
#import "User.h"

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
       
       // Success
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
       
       
       // Cache it
       //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       //[[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];

       //if (completion) { completion(tweetDictionaries, nil); }
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if (completion) { completion(nil, error); }
   }];
}


- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getUserTweets:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion{

    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@", user.screenName];
//    NSLog(urlString);
    //NSDictionary *parameters = @{@"screen_name": user.screenName};
    [self GET:urlString
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionaries) {
        // Success
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)verifyCredsWithCompletion:(void (^)(NSDictionary *userInfo, NSError *error))completion {
    
    NSString *urlString = [NSString stringWithFormat:@"1.1/account/verify_credentials.json"];
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDictionary) {
        // Success
        completion(userDictionary, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getNumberOfTweets:(NSNumber *)numTweets completion:(void (^)(NSArray *tweets, NSError *error))completion{
    
    NSString *urlString = @"1.1/statuses/home_timeline.json";
    //    NSLog(urlString);
    NSDictionary *parameters = @{@"count": numTweets};
    [self GET:urlString
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionaries) {
       // Success
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}


@end
