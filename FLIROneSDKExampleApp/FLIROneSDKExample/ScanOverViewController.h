//
//  ScanOverViewController.h
//  FLIROneSDKExampleApp
//
//  Created by Nataly Moreno on 2/25/15.
//  Copyright (c) 2015 Nataly Moreno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanOverViewController : UIViewController
@property (nonatomic, retain) NSString *prev_view;

- (UIButton*)makeCircularButton:(UIButton*)abutton withImage:(NSString*)imName atXLoc:(NSInteger)xLoc atYLoc:(NSInteger)yLoc;

@end
