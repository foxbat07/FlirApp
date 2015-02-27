//
//  PatientInformationViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Nataly Moreno on 2/25/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "PatientInformationViewController.h"
#import "SelectPatientViewController.h"

#import <QuartzCore/QuartzCore.h>

#define ROUND_BUTTON_RADIUS 50

@interface PatientInformationViewController ()
@property (nonatomic) UIColor *bg_color;
@property (nonatomic) UIColor *border_color;


@property (weak, nonatomic) IBOutlet UIButton *scanPatientButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *miNameText;
@property (weak, nonatomic) IBOutlet UITextField *sexText;
@property (weak, nonatomic) IBOutlet UITextField *dobText;
@property (weak, nonatomic) IBOutlet UITextField *heightText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation PatientInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.firstNameText.delegate = self;
	self.lastNameText.delegate = self;
	self.miNameText.delegate = self;
	self.sexText.delegate = self;
	self.dobText.delegate = self;
	self.heightText.delegate = self;
	self.weightText.delegate = self;
	self.emailText.delegate = self;
	
	// Do any additional setup after loading the view.
	self.bg_color = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
	self.view.backgroundColor = self.bg_color;
	
	
	self.border_color = [[UIColor alloc] initWithRed: 65.0 / 255.0
											   green: 120.0 / 255.0
												blue: 219.0 / 255.0
											   alpha: 1.0];
	
	//Hide Navigation Bar
	[self.navigationController setNavigationBarHidden:YES];
	
	//Customize Buttons
	self.backButton = [self makeCircularButton:self.backButton withImage:@"big_backArrow.png" atXLoc:20 atYLoc:510];
	[self.backButton addTarget:self action:@selector(goToScanOverview:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.backButton];
	
	//Customize TextFields
	self.firstNameText = [self addBorderToTextField:self.firstNameText withColor:self.border_color];
	self.lastNameText = [self addBorderToTextField:self.lastNameText withColor:self.border_color];
	self.miNameText = [self addBorderToTextField:self.miNameText withColor:self.border_color];
	self.sexText = [self addBorderToTextField:self.sexText withColor:self.border_color];
	self.dobText = [self addBorderToTextField:self.dobText withColor:self.border_color];
	self.heightText = [self addBorderToTextField:self.heightText withColor:self.border_color];
	self.weightText = [self addBorderToTextField:self.weightText withColor:self.border_color];
	self.emailText = [self addBorderToTextField:self.emailText withColor:self.border_color];

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

- (IBAction)goToScanOverview:(id)sender {
	SelectPatientViewController *scanview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectPatientView"];
	
	[self.navigationController pushViewController:scanview animated:YES];
}

- (UITextField*)addBorderToTextField:(UITextField*)textField withColor:(UIColor *)border_color {
	textField.layer.cornerRadius  = 8.0f;
	textField.layer.masksToBounds = YES;
	//textField.layer.borderColor   = [[UIColor redColor]CGColor];
	textField.layer.borderColor   = [border_color CGColor];

	textField.layer.borderWidth   = 0.5f;
	return textField;
}

//code from: https://looksok.wordpress.com/2013/02/02/ios-tutorial-hide-keyboard-after-return-done-key-press-in-uitextfield/
//http://stackoverflow.com/questions/19647096/dismiss-the-keyboard-multiple-uitextfields-in-ios-7
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end













