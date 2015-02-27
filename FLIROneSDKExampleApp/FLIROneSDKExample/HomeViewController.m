//
//  HomeViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Nataly Moreno on 2/25/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "HomeViewController.h"
#import "ScanOverViewController.h"
#import "SelectPatientViewController.h"

#import <QuartzCore/QuartzCore.h>

#define ROUND_BUTTON_WIDTH_HEIGHT 70

@interface HomeViewController ()



@property (weak, nonatomic) IBOutlet UIButton *trialButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *recordsButton;


@property (nonatomic) UIColor *bg_color;
@property (nonatomic) UIColor *border_color;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Set Colors
	self.bg_color     = [[UIColor alloc] initWithRed: 0.0
										       green: 0.0
											    blue: 0.0
										       alpha: 1.0];
	
	self.border_color = [[UIColor alloc] initWithRed: 65.0 / 255.0
											   green: 120.0 / 255.0
												blue: 219.0 / 255.0
											   alpha: 1.0];
	
    // Do any additional setup after loading the view.
	self.view.backgroundColor = self.bg_color;
	
	//Hide Navigation Bar
	[self.navigationController setNavigationBarHidden:YES];
	
	self.trialButton = [self makeCircularButton:self.trialButton withImage:@"trial.png" atXLoc:40 atYLoc:150];
	[self.trialButton addTarget:self action:@selector(goToScanOverview:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.trialButton];

	
	self.scanButton = [self makeCircularButton:self.scanButton withImage:@"newscan.png" atXLoc:40 atYLoc:250];
	[self.scanButton addTarget:self action:@selector(goToSelectPatient:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.scanButton];
	
	
	self.recordsButton = [self makeCircularButton:self.recordsButton withImage:@"accessrecords.png" atXLoc:40 atYLoc:350];
	[self.recordsButton addTarget:self action:@selector(goToRecords:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.recordsButton];
}

//code from: http://stackoverflow.com/questions/6952755/how-to-create-a-round-button/6954024#6954024
- (UIButton*)makeCircularButton:(UIButton*)abutton withImage:(NSString*)imName atXLoc:(NSInteger)xLoc atYLoc:(NSInteger)yLoc {
	abutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[abutton setImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
	//[abutton addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	abutton.frame = CGRectMake(xLoc, yLoc, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
	abutton.clipsToBounds = YES;
	abutton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
	abutton.layer.borderColor = self.border_color.CGColor;
	abutton.layer.borderWidth = 2.0f;
	//[self.view addSubview:abutton];
	return abutton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToScanOverview:(UIButton*)tappedButton{
	//NSLog(@"goToScanOverview Method Called");

	ScanOverViewController *scanview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanOverView"];
	
	scanview.prev_view = @"HomeViewController";
	
	[self.navigationController pushViewController:scanview animated:YES];

	//DEBUG
	//NSLog(@"%@", scanview);
	//NSLog(@"%@", self.navigationController);
}

- (void)goToSelectPatient:(UIButton*)tappedButton{
	//NSLog(@"goToSelectPatient Method Called");
	
	SelectPatientViewController *selectPatientView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectPatientView"];
	
	[self.navigationController pushViewController:selectPatientView animated:YES];
	
	//DEBUG
	//NSLog(@"%@", selectPatientView);
	//NSLog(@"%@", self.navigationController);
}

- (void)goToRecords:(UIButton*)tappedButton{
	NSLog(@"goToRecords Method Called: Not implemented yet.");
	
	//SelectPatientViewController *selectPatientView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectPatientView"];
	
	//[self.navigationController pushViewController:selectPatientView animated:YES];
	
	//DEBUG
	//NSLog(@"%@", selectPatientView);
	//NSLog(@"%@", self.navigationController);
}

@end
