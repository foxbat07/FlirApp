//
//  FlirOneSDKOurMainViewController.m
//  userInterface
//
//  Created by Nataly Moreno on 2/9/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "FlirOneSDKOurMainViewController.h"

@interface FlirOneSDKOurMainViewController ()

@end

@implementation FlirOneSDKOurMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[[FLIROneSDKStreamManager sharedInstance] addDelegate:self];

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
