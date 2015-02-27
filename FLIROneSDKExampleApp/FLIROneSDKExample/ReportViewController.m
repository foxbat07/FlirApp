//
//  ReportViewController.m
//  [IN]Flame
//
//  Created by Nataly Moreno on 2/26/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "ReportViewController.h"
#import "HomeViewController.h"
#import "ScanOverViewController.h"

#define ROUND_BUTTON_RADIUS 50

@interface ReportViewController ()
@property (nonatomic) UIColor *bg_color;
@property (nonatomic) UIColor *border_color;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	self.bg_color = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
	self.view.backgroundColor = self.bg_color;
	
	self.border_color = [[UIColor alloc] initWithRed: 65.0 / 255.0
											   green: 120.0 / 255.0
												blue: 219.0 / 255.0
											   alpha: 1.0];
	
	self.backButton = [self makeCircularButton:self.backButton withImage:@"big_GoArrow.png" atXLoc:250 atYLoc:510];
	[self.backButton addTarget:self action:@selector(goToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.backButton];
	
	self.backButton = [self makeCircularButton:self.backButton withImage:@"big_backArrow.png" atXLoc:20 atYLoc:510];
	[self.backButton addTarget:self action:@selector(goToScanOverview:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.backButton];
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

- (void)goToMainMenu:(UIButton*)tappedButton{
	//NSLog(@"goToSelectPatient Method Called");
	
	HomeViewController *mainView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
	
	[self.navigationController pushViewController:mainView animated:YES];
}

- (void)goToScanOverview:(UIButton*)tappedButton{
	//NSLog(@"goToSelectPatient Method Called");
	
	ScanOverViewController *scanView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanOverView"];
	
	[self.navigationController pushViewController:scanView animated:YES];
}

@end
