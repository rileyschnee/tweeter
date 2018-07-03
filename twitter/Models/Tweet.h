//
//  Tweet.h
//  twitter
//
//  Created by Riley Schnee on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *idStr;            // For fav, retweet and reply
@property (nonatomic, strong) NSString *text;             // Tweet contents
@property (nonatomic, strong) User *user;                 // Name and screen name of poster
@property (nonatomic, strong) NSString *createdAtString;  // Display date
@property (nonatomic) BOOL *favorited;
@property (nonatomic) int favoriteCount;
@property (nonatomic) BOOL *retweeted;
@property (nonatomic) int retweetCount;
@property (nonatomic, strong) User *retweetedByUser;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

@end
