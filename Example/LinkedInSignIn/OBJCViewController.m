//
//  OBJCViewController.m
//  LinkedInSignIn_Example
//
//  Created by Serhii Londar on 3/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "OBJCViewController.h"
@import LinkedInSignIn;

@interface OBJCViewController ()

@end

@implementation OBJCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    LinkedInConfig *config = [[LinkedInConfig alloc] initWithLinkedInKey:@"" linkedInSecret:@"" redirectURL:@"" scope:@""];
    LinkedinHelper *helper = [[LinkedinHelper alloc] initWithLinkedInConfig:config];
    [helper loginFrom:self loadingTitleString:@"Loading" loadingTitleFont:nil navigationColor:[UIColor redColor] completion:^(NSString * _Nonnull token) {
        
    } failure:^(NSError * _Nonnull error) {
        
    } cancel:^{
        
    }];
}

@end
