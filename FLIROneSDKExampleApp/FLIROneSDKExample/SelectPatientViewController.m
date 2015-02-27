//
//  SelectPatientViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Nataly Moreno on 2/25/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "SelectPatientViewController.h"
#import "HomeViewController.h"

#define BUTTON_RADIUS 50


@interface SelectPatientViewController ()
@property (nonatomic) UIColor *bg_color;
@property (nonatomic) UIColor *border_color;
@property (nonatomic) UIColor *text_color;
@property (nonatomic) UIColor *placeholderText_color;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchPatientBar;
@end

@implementation SelectPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	self.bg_color = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
	self.view.backgroundColor = self.bg_color;
	
	self.border_color = [[UIColor alloc] initWithRed: 65.0 / 255.0
											   green: 120.0 / 255.0
												blue: 219.0 / 255.0
											   alpha: 1.0];
	
	self.text_color = [[UIColor alloc] initWithRed: 40.0 / 255.0
											 green: 156.0 / 255.0
											  blue: 76.0 / 255.0
											 alpha: 1.0];
	
	self.placeholderText_color = [[UIColor alloc] initWithRed: 123.0 / 255.0
														green: 197.0 / 255.0
														 blue: 233.0 / 255.0
														alpha: 1.0];
	
	self.backButton = [self makeCircularButton:self.backButton withImage:@"big_backArrow.png" atXLoc:10 atYLoc:20];
	[self.backButton addTarget:self action:@selector(goToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.backButton];
	//- (void)setImage:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state;

	//[self.myTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	
	//Customize Search Patient Bar
	//[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];

	//[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:self.border_color];

	
	//Code From: http://stackoverflow.com/questions/11827585/uisearchbar-change-placeholder-color
	UITextField *searchField = [self.searchPatientBar valueForKey:@"_searchField"];
	
	// Change search bar text color
	searchField.textColor = self.placeholderText_color;
	searchField.backgroundColor = [UIColor blackColor];
	
	// Change the search bar placeholder text color
	[searchField setValue:self.text_color forKeyPath:@"_placeholderLabel.textColor"];
	
	//self.searchPatientBar.tintColor = [UIColor blackColor];
	//[[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar.png"]forState:UIControlStateNormal];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//code from: http://stackoverflow.com/questions/6952755/how-to-create-a-round-button/6954024#6954024
- (UIButton*)makeCircularButton:(UIButton*)abutton withImage:(NSString*)imName atXLoc:(NSInteger)xLoc atYLoc:(NSInteger)yLoc {
	abutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[abutton setImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
	abutton.frame = CGRectMake(xLoc, yLoc, BUTTON_RADIUS, BUTTON_RADIUS);
	abutton.clipsToBounds = YES;
	abutton.layer.cornerRadius = BUTTON_RADIUS/2.0f;
	abutton.layer.borderColor = self.border_color.CGColor;
	abutton.layer.borderWidth = 2.0f;
	return abutton;
}

- (void)goToMainMenu:(UIButton*)tappedButton{
	HomeViewController *mainView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
	
	[self.navigationController pushViewController:mainView animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//hides keyboard when another part of layout was touched
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

@end
