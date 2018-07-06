//
//  ComposeViewController.m
//  twitter
//
//  Created by Riley Schnee on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetContent.delegate = self;
    
    if(self.isAReply){
        self.tweetContent.text = [NSString stringWithFormat:@"@%@ ", self.replyTo.user.screenName];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapPost:(id)sender {
    [[APIManager shared]postStatusWithText:self.tweetContent.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
    }];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)didTapCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetContent.text stringByReplacingCharactersInRange:range withString:text];
    
    // TODO: Update Character Count Label
    self.wordCount.text = [NSString stringWithFormat:@"%lu / %i", self.tweetContent.text.length, characterLimit];
    
    // The new text should be allowed? True/False
    return newText.length < characterLimit;
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
