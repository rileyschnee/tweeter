//
//  TweetCell.m
//  twitter
//
//  Created by Riley Schnee on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "Tweet.h"

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
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.favoriteCount.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.createdAt.text = self.tweet.createdAtString;
    self.text.text = self.tweet.text;
    self.profileImage.image = nil;
    self.profileImage.alpha = 1.0;
    if (self.tweet.user.profilePicURL != nil) {
        [self.profileImage setImageWithURL:self.tweet.user.profilePicURL];
    }
    self.retweetButton.highlighted = self.tweet.retweeted;
    self.favoriteButton.highlighted = self.tweet.favorited;

    //[UIView animateWithDuration:0.2 animations:^{
    //    self.profileImage.alpha = 1.0;
    //}];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                self.retweetButton.highlighted = NO;
                self.retweetCount.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
            }
        }];
        
    }else{
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                self.retweetButton.highlighted = YES;
                self.retweetCount.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
            }
        }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                self.favoriteButton.highlighted = NO;
                self.favoriteCount.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
            }
        }];
        
    }else{
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
            NSLog(@"Error favoriting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                self.favoriteButton.highlighted = YES;
                self.favoriteCount.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
            }
        }];
    }
}
- (void)resetData{
    
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
}




@end
