//
//  TweetViewController.m
//  twitter
//
//  Created by Riley Schnee on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetContentLabel.text = self.tweet.text;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.retweetButton.highlighted = self.tweet.retweeted;
    self.favoriteButton.highlighted = self.tweet.favorited;
    self.profilePicView.image = nil;
    self.profilePicView.alpha = 1.0;
    if (self.tweet.user.profilePicURL != nil) {
        [self.profilePicView setImageWithURL:self.tweet.user.profilePicURL];
    }
    if (self.tweet.mediaURL != nil) {
        [self.tweetImageView setImageWithURL:self.tweet.mediaURL];
    }
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
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
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
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
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
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
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
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
            }
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
