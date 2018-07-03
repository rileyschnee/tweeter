//
//  TweetCell.m
//  twitter
//
//  Created by Riley Schnee on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.userName.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    self.favoriteCount.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.createdAt.text = self.tweet.createdAtString;
    self.text.text = self.tweet.text;
    self.profileImage.image = nil;
    self.profileImage.alpha = 1.0;
    if (self.tweet.user.profilePicURL != nil) {
        [self.profileImage setImageWithURL:self.tweet.user.profilePicURL];
    }
    //[UIView animateWithDuration:0.2 animations:^{
   //     self.profileImage.alpha = 1.0;
    //}];
}

@end
