//
//  FLIROneSDKExampleViewController.h
//  FLIROneSDKExample
//
//  Created by Joseph Colicchio on 5/22/14.
//  Copyright (c) 2014 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <FLIROneSDK/FLIROneSDK.h>
//#import <FlirOneFramework/FLIROne.h>

@interface FLIROneSDKExampleViewController : UIViewController <FLIROneSDKImageReceiverDelegate, FLIROneSDKStreamManagerDelegate, FLIROneSDKVideoRendererDelegate, FLIROneSDKImageEditorDelegate>

@property (nonatomic, retain) NSString *chosen_scan_mode;
@property (nonatomic, retain) NSString *prev_view;

//@interface FLIROneSDKExampleViewController : UIViewController <FLIROneDeviceDelegate>

@end
