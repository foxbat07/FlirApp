//
//  ScanOverViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Nataly Moreno on 2/25/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "ScanOverViewController.h"
#import "HomeViewController.h"
#import "PatientInformationViewController.h"
#import "ReportViewController.h"
#import "FLIROneSDKExampleViewController.h"

#import <QuartzCore/QuartzCore.h>

#define ROUND_BUTTON_RADIUS 50

@interface ScanOverViewController ()
@property (nonatomic) UIColor *bg_color;
@property (nonatomic) UIColor *border_color;
@property (nonatomic) NSString *scan_mode;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *patientInfoButton;

//OverImage Joint Buttons
@property (weak, nonatomic) IBOutlet UIButton *rightArmButton;
@property (weak, nonatomic) IBOutlet UIButton *leftArmButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *rightLegButton;
@property (weak, nonatomic) IBOutlet UIButton *leftLegButton;

//Image
@property (weak, nonatomic) IBOutlet UIImageView *blueGuyImage;

@end

@implementation ScanOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Hide Navigation Bar
	[self.navigationController setNavigationBarHidden:YES];
	
    // Do any additional setup after loading the view.
	self.bg_color = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
	self.view.backgroundColor = self.bg_color;
	
	self.border_color = [[UIColor alloc] initWithRed: 65.0 / 255.0
											   green: 120.0 / 255.0
												blue: 219.0 / 255.0
											   alpha: 1.0];

	[self.view sendSubviewToBack:self.goButton];
	[self.view sendSubviewToBack:self.backButton];

	//Set Up the Back Button
	self.backButton = [self makeCircularButton:self.backButton withImage:@"big_backArrow.png" atXLoc:20 atYLoc:510];
	
	if([self.prev_view isEqual: @"HomeViewController"])
	{
		[self.backButton addTarget:self action:@selector(goToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
	}
	else
	{
		[self.backButton addTarget:self action:@selector(goToPatientInfo:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	[self.view addSubview:self.backButton];

	//Set Up the Go Button
	self.goButton = [self makeCircularButton:self.goButton withImage:@"big_GoArrow.png" atXLoc:250 atYLoc:510];
	
	if([self.prev_view isEqual: @"HomeViewController"])
	{
		[self.goButton addTarget:self action:@selector(goToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
	}
	else
	{
		[self.goButton addTarget:self action:@selector(goToReport:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	[self.view addSubview:self.goButton];
	
	
	//Button Borders and Listeners
	self.rightArmButton.layer.borderWidth=1.0f;
	self.rightArmButton.layer.borderColor=[self.border_color CGColor];
	[self.rightArmButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchUpInside];
	
	self.leftArmButton.layer.borderWidth = 1.0f;
	self.leftArmButton.layer.borderColor = [self.border_color CGColor];
	[self.leftArmButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchUpInside];
	
	self.headButton.layer.borderWidth = 1.0f;
	self.headButton.layer.borderColor = [self.border_color CGColor];
	[self.headButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchUpInside];
	
	self.rightLegButton.layer.borderWidth = 1.0f;
	self.rightLegButton.layer.borderColor = [self.border_color CGColor];
	[self.rightLegButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchUpInside];
	
	self.leftLegButton.layer.borderWidth = 1.0f;
	self.leftLegButton.layer.borderColor=[self.border_color CGColor];
	[self.leftLegButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//code from: http://stackoverflow.com/questions/6952755/how-to-create-a-round-button/6954024#6954024
- (UIButton*)makeCircularButton:(UIButton*)abutton withImage:(NSString*)imName atXLoc:(NSInteger)xLoc atYLoc:(NSInteger)yLoc {
	abutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[abutton setImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
	abutton.frame = CGRectMake(xLoc, yLoc, ROUND_BUTTON_RADIUS, ROUND_BUTTON_RADIUS);
	abutton.clipsToBounds = YES;
	abutton.layer.cornerRadius = ROUND_BUTTON_RADIUS/2.0f;
	abutton.layer.borderColor = self.border_color.CGColor;
	abutton.layer.borderWidth = 2.0f;
	return abutton;
}

- (void)goToMainMenu:(UIButton*)tappedButton {
	//NSLog(@"goToSelectPatient Method Called");
	
	HomeViewController *mainView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
	
	[self.navigationController pushViewController:mainView animated:YES];
}

- (void)goToPatientInfo:(UIButton*)tappedButton {
	//NSLog(@"goToSelectPatient Method Called");
	
	PatientInformationViewController *selectPatientView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PatientInfoView"];
	
	[self.navigationController pushViewController:selectPatientView animated:YES];
}

- (void)goToReport:(UIButton*)tappedButton {
	//NSLog(@"goToSelectPatient Method Called");
	
	ReportViewController *reportView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportView"];
	
	[self.navigationController pushViewController:reportView animated:YES];
}

- (void)goToCameraView:(UIButton*)tappedButton {
	//NSLog(@"goToSelectPatient Method Called");
	
	FLIROneSDKExampleViewController *camView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CameraView"];
		
	////NSLog(@"%@", tappedButton.currentTitle);

	if([tappedButton.currentTitle isEqualToString:@"head"])
		camView.chosen_scan_mode = @"Scan Head";
	else if ([tappedButton.currentTitle isEqualToString:@"rightArm"])
		camView.chosen_scan_mode = @"Scan Right Arm";
	else if ([tappedButton.currentTitle isEqualToString:@"leftArm"])
		camView.chosen_scan_mode = @"Scan Left Arm";
	else if ([tappedButton.currentTitle isEqualToString:@"rightLeg"])
		camView.chosen_scan_mode = @"Scan Right Leg";
	else if ([tappedButton.currentTitle isEqualToString:@"leftLeg"])
		camView.chosen_scan_mode = @"Scan Left Leg";

	camView.prev_view = self.prev_view;

	[self.navigationController pushViewController:camView animated:YES];
}

@end
















