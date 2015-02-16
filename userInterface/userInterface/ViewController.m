//
//  ViewController.m
//  userInterface
//
//  Created by Nataly Moreno on 2/7/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import "ViewController.h"

#import <FLIROneSDK/FLIROneSDKLibraryViewController.h>

#import <AVFoundation/AVFoundation.h>

#import <FLIROneSDK/FLIROneSDKUIImage.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager
 didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage imageSize:(CGSize)size {
	//render the image
	UIImage *image = [FLIROneSDKUIImage
					  imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image andData:msxImage andSize:size];
	//perform ui update on main thread
	dispatch_async(dispatch_get_main_queue(), ^{
		self.imageView.image = image;
	});
	
}
*/
@end
