//
//  User.m
//  twitter
//
//  Created by Riley Schnee on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicURLString = dictionary[@"profile_image_url_https"];
        self.profilePicURL = [NSURL URLWithString:self.profilePicURLString];
        self.headerPicURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.bio = dictionary[@"description"];
        self.idStr = dictionary[@"user_id"];
        self.followers = (int)dictionary[@"followers_count"];
        self.following = (int)dictionary[@"friends_count"];
    }
    return self;
}
    
    
@end
