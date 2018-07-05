//
//  ComposeViewController.h
//  twitter
//
//  Created by Riley Schnee on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) TweetCell *replyTo;
@property (nonatomic) BOOL isAReply;

@end
