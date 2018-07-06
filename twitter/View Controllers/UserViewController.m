//
//  UserViewController.m
//  twitter
//
//  Created by Riley Schnee on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "UserViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) NSArray *userTweets;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([self.restorationIdentifier isEqual:@"myProfile"]) {
        NSLog(@"User ID set to current user.");

        [[APIManager shared] verifyCredsWithCompletion:^(NSDictionary *userInfo, NSError *error) {
            self.userProf = [[User alloc] initWithDictionary:userInfo];
        }];
    }
    self.nameLabel.text = self.userProf.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.userProf.screenName];
    [self.profilePicView setImageWithURL:self.userProf.profilePicURL];
    self.profilePicView.layer.cornerRadius = 15;
    self.profilePicView.layer.borderWidth = 1.0;
    self.profilePicView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.headerView setImageWithURL:self.userProf.headerPicURL];
    self.bioLabel.text = self.userProf.bio;
    self.followersLabel.text = [NSString stringWithFormat:@"%i", self.userProf.followers];
    self.followingLabel.text = [NSString stringWithFormat:@"%i", self.userProf.following];
    [[APIManager shared] getUserTweets:self.userProf completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"Successfully got USER TWEETS");
            for (Tweet *tweet in tweets) {
             NSString *text = tweet.text;
             NSLog(@"%@", text);
             }
            
            self.userTweets = tweets;
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
    }];
    
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.userTweets[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userTweets.count;
}

@end
