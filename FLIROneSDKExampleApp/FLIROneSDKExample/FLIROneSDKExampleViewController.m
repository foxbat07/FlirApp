//
//  FLIROneSDKExampleViewController.m
//  FLIROneSDKExample
//
//  Created by Joseph Colicchio on 5/22/14.
//  Copyright (c) 2014 novacoast. All rights reserved.
//

#import "FLIROneSDKExampleViewController.h"

#import <FLIROneSDK/FLIROneSDKLibraryViewController.h>

#import <AVFoundation/AVFoundation.h>

#import <FLIROneSDK/FLIROneSDKUIImage.h>


@interface FLIROneSDKExampleViewController ()

//The main viewfinder for the FLIR ONE
@property (weak, nonatomic) IBOutlet UIView *masterImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thermalImageView;
@property (strong, nonatomic) IBOutlet UIImageView *radiometricImageView;
@property (strong, nonatomic) IBOutlet UIButton *thermalButton;
//@property (strong, nonatomic) IBOutlet UIButton *thermal14BitButton;

//labels outlining various camera information
@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *tuningStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryChargingLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryPercentageLabel;

@property (strong, nonatomic) IBOutlet UILabel *frameCountLabel;

@property (strong, nonatomic) IBOutlet UIButton *paletteButton;

@property (strong, nonatomic) IBOutlet UIButton *emissivityButton;
@property (strong, nonatomic) IBOutlet UIButton *msxButton;

@property (strong, nonatomic) UIView *regionView;
@property (strong, nonatomic) UILabel *regionMinLabel;
@property (strong, nonatomic) UILabel *regionMaxLabel;
@property (strong, nonatomic) UILabel *regionAverageLabel;

@property (strong, nonatomic) UIView *hottestPoint;
@property (strong, nonatomic) UILabel *hottestLabel;
@property (strong, nonatomic) UIView *coldestPoint;
@property (strong, nonatomic) UILabel *coldestLabel;

@property (strong, nonatomic) NSData *thermalData;
@property (nonatomic) CGSize thermalSize;

//buttons for interacting with the FLIR ONE
//view library
@property (nonatomic, strong) IBOutlet UIButton *libraryButton;
//capture photo
@property (nonatomic, strong) IBOutlet UIButton *capturePhotoButton;
//capture video
@property (nonatomic, strong) IBOutlet UIButton *captureVideoButton;
//swap palettes, button overlays the viewfinder
//@property (nonatomic, strong) UIButton *imageButton;

//data for UI to display
@property (strong, nonatomic) UIImage *thermalImage;
@property (strong, nonatomic) UIImage *radiometricImage;

//@property (strong, nonatomic) FLIROneSDKUIImage *sdkImage;

@property (strong, nonatomic) NSDictionary *spotTemperatures;
@property (strong, nonatomic) FLIROneSDKPalette *palette;
@property (nonatomic) NSUInteger paletteCount;

@property (nonatomic) BOOL connected;

@property (nonatomic) FLIROneSDKTuningState tuningState;

@property (nonatomic) FLIROneSDKBatteryChargingState batteryChargingState;
@property (nonatomic) NSInteger batteryPercentage;

//@property (nonatomic) FLIROneSDKEmissivity *emissivity;
@property (nonatomic) CGFloat emissivity;
@property (nonatomic) FLIROneSDKImageOptions options;

@property (nonatomic) BOOL pixelDataExists;
@property (nonatomic) CGPoint pixelOfInterest;
@property (nonatomic) CGPoint coldPixel;
@property (nonatomic) CGFloat pixelTemperature;
@property (nonatomic) CGFloat coldestTemperature;

@property (nonatomic) BOOL regionDataExists;
@property (nonatomic) CGRect regionOfInterest;
@property (nonatomic) CGFloat regionMinTemperature;
@property (nonatomic) CGFloat regionMaxTemperature;
@property (nonatomic) CGFloat regionAverageTemperature;

@property (nonatomic) BOOL msxDistanceEnabled;

@property (strong, nonatomic) dispatch_queue_t renderQueue;
//@property (strong, nonatomic) NSData *imageData;

@property (nonatomic) NSTimeInterval lastTime;
@property (nonatomic) CGFloat fps;

//capturing video stuff

//if the user is capturing a video or in the process of recording, the camera is "busy", block requests to capture more media
@property (nonatomic) BOOL cameraBusy;

//if there is currently a video being recorded
@property (nonatomic) BOOL currentlyRecording;
//is the image finished recording, and currently wrapping up the file write process?
@property (nonatomic) BOOL savingVideo;

@property (nonatomic) NSInteger frameCount;

@end

@implementation FLIROneSDKExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UI stuff
    self.thermalImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.radiometricImageView.contentMode = UIViewContentModeScaleAspectFit;
	
    self.regionView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionView];
    self.regionView.backgroundColor = [UIColor greenColor];
    self.regionView.alpha = 0.5;
    
    self.regionMinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionMinLabel];
    self.regionMaxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionMaxLabel];
    self.regionAverageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionAverageLabel];
    
    self.hottestPoint = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.hottestPoint];
    self.hottestPoint.backgroundColor = [UIColor redColor];
    self.hottestPoint.alpha = 0.5;
    self.hottestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.hottestLabel];
    
    self.coldestPoint = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.coldestPoint];
    self.coldestPoint.backgroundColor = [UIColor blueColor];
    self.coldestPoint.alpha = 0.5;
    self.coldestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.coldestLabel];
    
    //center of screen, half width half height, offset by width/4, height/4
    self.regionOfInterest = CGRectMake(0.25, 0.25, 0.5, 0.5);
    
    //create a queue for rendering
    self.renderQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //set the options to MSX blended
    self.options = FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
    
    
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    
    [[FLIROneSDKStreamManager sharedInstance] setImageOptions:self.options];
    
    self.cameraBusy = NO;
    
    self.paletteCount = 0;
    
    [self updateUI];
}

- (IBAction) switchPalette:(UIButton *)button {
    NSInteger paletteIndex = [[[FLIROneSDKPalette palettes] allValues] indexOfObject:self.palette];
    if(paletteIndex >= 0) {
        self.paletteCount = paletteIndex;
    }
    self.paletteCount = ((self.paletteCount+1) % [[FLIROneSDKPalette palettes] count]);
    FLIROneSDKPalette *palette = [[[FLIROneSDKPalette palettes] allValues] objectAtIndex:self.paletteCount];
    
    [[FLIROneSDKStreamManager sharedInstance] setPalette:palette];
}

- (void) updateUI {
    //updates the UI based on the state of the sled
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.thermalImageView setImage:self.thermalImage];
		
		//NEW CODE COPIED FROM RADIOMETRIC IMAGE
		if(self.thermalData && self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
			//find hottest point
			//self.hottestPoint.hidden = NO;
			
			@synchronized(self) {
				[self performTemperatureCalculations];
			}
			
			self.pixelDataExists = true;
			self.regionDataExists = true;
			
		} else {
			self.pixelDataExists = false;
			self.regionDataExists = false;
		}
		
		
		
        [self.radiometricImageView setImage:self.radiometricImage];
		
		
        /*if(self.thermalData && self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
            //find hottest point
            //self.hottestPoint.hidden = NO;

            @synchronized(self) {
                [self performTemperatureCalculations];
            }
            
            self.pixelDataExists = true;
            self.regionDataExists = true;
            
        } else {
            self.pixelDataExists = false;
            self.regionDataExists = false;
        }*/
        
        if(self.palette)
            [self.paletteButton setTitle:[NSString stringWithFormat:@"%@", [self.palette name]] forState:UIControlStateNormal];
        else
            [self.paletteButton setTitle:@"N/A" forState:UIControlStateNormal];
        
        if(self.connected) {
            [self.connectionLabel setText:@"Connected"];
            [self.capturePhotoButton setEnabled:!self.cameraBusy];
            [self.captureVideoButton setEnabled:(!self.cameraBusy || self.currentlyRecording)];
        } else {
            [self.connectionLabel setText:@"Disconnected"];
            [self.capturePhotoButton setEnabled:NO];
            [self.captureVideoButton setEnabled:NO];
        }
        
        NSString *tuningStateString;
        switch(self.tuningState) {
            case FLIROneSDKTuningStateTuningSuggested:
                tuningStateString = @"Tuning Suggested";
                break;
            case FLIROneSDKTuningStateInProgress:
                tuningStateString = @"Tuning Progress";
                break;
            case FLIROneSDKTuningStateUnknown:
                tuningStateString = @"Tuning Unknown";
                break;
            case FLIROneSDKTuningStateTunedWithClosedShutter:
                tuningStateString = @"Tuned Closed";
                break;
            case FLIROneSDKTuningStateTunedWithOpenedShutter:
                tuningStateString = @"Tuned Open";
                break;
            case FLIROneSDKTuningStateTuningRequired:
                tuningStateString = @"Tuning Required";
                break;
            case FLIROneSDKTuningStateApproximatelyTunedWithOpenedShutter:
                tuningStateString = @"Tuned Approx.";
                break;
        }
        [self.tuningStateLabel setText:[NSString stringWithFormat:@"%@", tuningStateString]];
        
        [self.versionLabel setText:[[FLIROneSDK sharedInstance] version]];
        
        [self.batteryPercentageLabel setText:[NSString stringWithFormat:@"Battery: %ld%%", (long)self.batteryPercentage]];
        
        
        NSString *chargingState;
        switch(self.batteryChargingState) {
            case FLIROneSDKBatteryChargingStateCharging:
                chargingState = @"Yes";
                break;
            case FLIROneSDKBatteryChargingStateDischarging:
                chargingState = @"No";
                break;
                
            case FLIROneSDKBatteryChargingStateError:
                chargingState = @"Err";
                break;
            case FLIROneSDKBatteryChargingStateInvalid:
                chargingState = @"Invalid";
                break;
            default:
                chargingState = @"N/A";
                break;
        }
        [self.batteryChargingLabel setText:[NSString stringWithFormat:@"Charging: %@", chargingState]];
        
        
        if(self.currentlyRecording) {
            [self.captureVideoButton setTitle:@"Stop Video" forState:UIControlStateNormal];
        } else {
            [self.captureVideoButton setTitle:@"Start Video" forState:UIControlStateNormal];
        }
        
        [self.msxButton setTitle:[NSString stringWithFormat:@"MSX Distance: %@", (self.msxDistanceEnabled ? @"On" : @"Off")] forState:UIControlStateNormal];
        [self.emissivityButton setTitle:[NSString stringWithFormat:@"Emissivity: %0.2f", self.emissivity] forState:UIControlStateNormal];
        
        self.frameCountLabel.text = [NSString stringWithFormat:@"Count: %ld, %f", (long)self.frameCount, self.fps];
        
        //update the positions of the hottest, coldest, and temperature region views/labels
        //CGSize imageSize = self.radiometricImageView.frame.size;
        //CGPoint imageOrigin = self.radiometricImageView.frame.origin;
		//NEW USE THERMAL INSTEAD OF RADIOMETRIC
		CGSize imageSize = self.thermalImageView.frame.size;
		CGPoint imageOrigin = self.thermalImageView.frame.origin;
		
        if(self.pixelDataExists) {
            CGRect frame = CGRectZero;
            CGFloat size = 30;
            frame.origin.x = imageOrigin.x + imageSize.width*self.pixelOfInterest.x - size/2.0;
            frame.origin.y = imageOrigin.y + imageSize.height*self.pixelOfInterest.y - size/2.0;
            frame.size.width = size;
            frame.size.height = size;
            self.hottestPoint.frame = frame;
            frame.size.width = 100;
            self.hottestLabel.frame = frame;
            self.hottestLabel.text = [NSString stringWithFormat:@"%0.2fºK", self.pixelTemperature];
            
            frame = CGRectZero;
            size = 30;
            frame.origin.x = imageOrigin.x + imageSize.width * self.coldPixel.x - size/2.0;
            frame.origin.y = imageOrigin.y + imageSize.height * self.coldPixel.y - size/2.0;
            frame.size.width = size;
            frame.size.height = size;
            self.coldestPoint.frame = frame;
            frame.size.width = 100;
            self.coldestLabel.frame = frame;
            self.coldestLabel.text = [NSString stringWithFormat:@"%0.2fºK", self.coldestTemperature];
        } else {
            self.hottestLabel.text = @"";
            self.hottestPoint.frame = CGRectZero;
            self.coldestLabel.frame = CGRectZero;
            self.coldestPoint.frame = CGRectZero;
        }
        
        if(self.regionDataExists) {
            CGRect frame = CGRectZero;
            frame.origin.x = imageOrigin.x + imageSize.width*self.regionOfInterest.origin.x;
            frame.origin.y = imageOrigin.y + imageSize.height*self.regionOfInterest.origin.y;
            frame.size.width = imageSize.width*self.regionOfInterest.size.width;
            frame.size.height = imageSize.height*self.regionOfInterest.size.height;
            self.regionView.frame = frame;
            frame.size.width = 100;
            frame.size.height = 30;
            self.regionMinLabel.frame = frame;
            frame.origin.y += 30;
            self.regionAverageLabel.frame = frame;
            frame.origin.y += 30;
            self.regionMaxLabel.frame = frame;
        } else {
            self.regionMaxLabel.text = @"";
            self.regionMinLabel.text = @"";
            self.regionAverageLabel.text = @"";
            self.regionView.frame = CGRectZero;
            self.regionMaxLabel.frame = CGRectZero;
            self.regionMinLabel.frame = CGRectZero;
            self.regionAverageLabel.frame = CGRectZero;
        }
    });
}

- (void) performTemperatureCalculations {
    uint16_t *tempData = (uint16_t *)[self.thermalData bytes];
    uint16_t temp = tempData[0];
    uint16_t hottestTemp = temp;
    uint16_t coldestTemp = temp;
    int index = 0;
    int coldIndex = 0;
    
    uint16_t minRegion = UINT16_MAX;
    int minRegionIndex = 0;
    uint16_t maxRegion = 0;
    int maxRegionIndex = 0;
    NSInteger regionCount = 0;
    NSInteger regionSum = 0;
    
    for(int i=0;i<self.thermalSize.width*self.thermalSize.height;i++) {
        temp = tempData[i];
        if(temp > hottestTemp) {
            hottestTemp = temp;
            index = i;
        }
        if(temp < coldestTemp) {
            coldestTemp = temp;
            coldIndex = i;
        }
        CGFloat x = (i % (int)self.thermalSize.width)/self.thermalSize.width;
        CGFloat y = (i / self.thermalSize.width)/self.thermalSize.height;
        
        if(x > self.regionOfInterest.origin.x
           && x < self.regionOfInterest.origin.x + self.regionOfInterest.size.width
           && y > self.regionOfInterest.origin.y
           && y < self.regionOfInterest.origin.y + self.regionOfInterest.size.height) {
            regionCount += 1;
            regionSum += temp;
            if(temp > maxRegion) {
                maxRegion = temp;
                maxRegionIndex = i;
            }
            if(temp < minRegion) {
                minRegion = temp;
                minRegionIndex = i;
            }
        }
    }
    uint16_t regionAverage = (regionSum/regionCount);
    
    self.regionMaxLabel.text = [NSString stringWithFormat:@"%0.2fºK", maxRegion/100.0];
    self.regionMinLabel.text = [NSString stringWithFormat:@"%0.2fºK", minRegion/100.0];
    self.regionAverageLabel.text = [NSString stringWithFormat:@"%0.2fºK", regionAverage/100.0];
    
    NSInteger column = index % (int)self.thermalSize.width;
    NSInteger row = index / self.thermalSize.width;
    //update the thinger
    CGPoint location = CGPointMake(column/self.thermalSize.width, row/self.thermalSize.height);
    //self.hottestPoint.frame = CGRectMake(
    self.pixelOfInterest = location;
    column = coldIndex % (int)self.thermalSize.width;
    row = coldIndex / self.thermalSize.width;
    
    location = CGPointMake(column/self.thermalSize.width, row/self.thermalSize.height);
    self.coldPixel = location;
    
    self.coldestTemperature = coldestTemp/100.0;
    self.pixelTemperature = hottestTemp/100.0;
}

//events relating to user tapping the image views, switches formats on and off

//NEVER TOGETHER
//FLIROneSDKImageOptionsThermalRGBA8888Image
//FLIROneSDKImageOptionsBlendedMSXRGBA8888Image

//cycle between thermal, MSX, and none
- (IBAction)thermalButtonPressed:(id)sender {
	/*if( self.options &   FLIROneSDKImageOptionsThermalRGBA8888Image) {
		self.options &= ~FLIROneSDKImageOptionsThermalRGBA8888Image;
		
		self.options |=  FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
		self.options |=  FLIROneSDKImageOptionsThermalRadiometricKelvinImage; //ADDED THIS LINE
		
	} else*/
		if(//self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image &&
			self.options & FLIROneSDKImageOptionsThermalRGBA8888Image &&
			  self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage &&
			  self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
		//self.options &=  ~FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
		self.options &=  ~FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
	} else {
		self.options |= FLIROneSDKImageOptionsThermalRGBA8888Image;
		self.options |= FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
		self.options |= FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
	}
	
	[FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
	
	//PREVIOUS
/*    if( self.options &   FLIROneSDKImageOptionsThermalRGBA8888Image) {
        self.options &= ~FLIROneSDKImageOptionsThermalRGBA8888Image;
        self.options |=  FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
		//self.options |=  FLIROneSDKImageOptionsThermalRadiometricKelvinImage; //ADDED THIS LINE
    } else if(self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
        self.options &=     ~FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
    } else {
        self.options |= FLIROneSDKImageOptionsThermalRGBA8888Image;
    }
	
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;*/
}
//cycle between 14 bit linear, radiometric, and none
/*- (IBAction)thermal14BitButtonPressed:(id)sender {
    if( self.options &   FLIROneSDKImageOptionsThermalLinearFlux14BitImage) {
        self.options &= ~FLIROneSDKImageOptionsThermalLinearFlux14BitImage;
        self.options |=  FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
    } else if(self.options &  FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
        self.options &=      ~FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
    } else {
        self.options |= FLIROneSDKImageOptionsThermalLinearFlux14BitImage;
    }
    
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
}
*/

- (void) FLIROneSDKDidConnect {
    self.connected = YES;
    self.frameCount = 0;
    
    [self updateUI];
}

- (void) FLIROneSDKDidDisconnect {
    self.connected = NO;
    @synchronized([FLIROneSDKExampleViewController class]) {
        if(self.currentlyRecording) {
            [[FLIROneSDKStreamManager sharedInstance] stopRecordingVideo];
        }
    }
    [self updateUI];
}


//callbacks for image data delivered from sled
- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveFrameWithOptions:(FLIROneSDKImageOptions)options metadata:(FLIROneSDKImageMetadata *)metadata {
    self.options = options;
    self.emissivity = metadata.emissivity;
    self.palette = metadata.palette;
    
    if(!(self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) && !(self.options & FLIROneSDKImageOptionsThermalRGBA8888Image)) {
        self.thermalImage = nil;
    }
	
	/*
    if(!(self.options & FLIROneSDKImageOptionsThermalLinearFlux14BitImage) && !(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage)) {
        self.radiometricImage = nil;
    }*/
    
    self.frameCount += 1;
    
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if(self.lastTime > 0) {
        self.fps = 1.0/(now - self.lastTime);
    }
    
    self.lastTime = now;
    
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage imageSize:(CGSize)size{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.thermalImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image andData:msxImage andSize:size];
        [self updateUI];
    });
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermalRGBA8888Image:(NSData *)thermalImage imageSize:(CGSize)size{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.thermalImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRGBA8888Image andData:thermalImage andSize:size];
        [self updateUI];
    });
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermal14BitLinearFluxImage:(NSData *)linearFluxImage imageSize:(CGSize)size {
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.radiometricImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalLinearFlux14BitImage andData:linearFluxImage andSize:size];
        [self updateUI];
    });
    */
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size {
    
    @synchronized(self) {
        self.thermalData = radiometricData;
        self.thermalSize = size;
    }
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.radiometricImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
        [self updateUI];
    });*/
    
    //[self updateUI];
}


//callbacks relating to capturing images to library
- (void) FLIROneSDKDidFinishCapturingPhoto:(FLIROneSDKCaptureStatus)captureStatus withFilepath:(NSURL *)filepath {
    self.cameraBusy = NO;
    [self updateUI];
}

//tuning callback
- (void) FLIROneSDKTuningStateDidChange:(FLIROneSDKTuningState)newTuningState {
    self.tuningState = newTuningState;
    [self updateUI];
}

//charging callback
- (void) FLIROneSDKBatteryChargingStateDidChange:(FLIROneSDKBatteryChargingState)state {
    self.batteryChargingState = state;
    [self updateUI];
}

//battery callback
- (void) FLIROneSDKBatteryPercentageDidChange:(NSNumber *)percentage {
    self.batteryPercentage = [percentage integerValue];
    [self updateUI];
}

//enable or disable MSX
- (IBAction) msxButtonPressed:(UIButton *)button {
    self.msxDistanceEnabled = !self.msxDistanceEnabled;
    
    [FLIROneSDKStreamManager sharedInstance].msxDistanceEnabled = YES;
    [FLIROneSDKStreamManager sharedInstance].msxDistance = self.msxDistanceEnabled ? 0 : 1;
    
}

//switch emissivity value to one of 5 values
- (IBAction) emissivityPressed:(UIButton *)button {
    CGFloat customValue = 0.5;
    
    if(fabs(self.emissivity - FLIROneSDKEmissivityGlossy) < 0.01) {
        self.emissivity = FLIROneSDKEmissivitySemiGlossy;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivitySemiGlossy) < 0.01) {
        self.emissivity = FLIROneSDKEmissivitySemiMatte;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivitySemiMatte) < 0.01) {
        self.emissivity = FLIROneSDKEmissivityMatte;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivityMatte) < 0.01) {
        self.emissivity = customValue;
    } else if(fabs(self.emissivity - customValue) < 0.01) {
        self.emissivity = FLIROneSDKEmissivityGlossy;
    } else {
        self.emissivity = customValue;
    }
    [[FLIROneSDKStreamManager sharedInstance] setEmissivity:self.emissivity];
}

- (IBAction)viewLibrary:(id)sender {
    [FLIROneSDKLibraryViewController presentLibraryFromViewController:self];
}

- (IBAction)capturePhoto:(id)sender {
    self.cameraBusy = YES;
    [self updateUI];
    
    
    NSURL *filepath = [[FLIROneSDKLibraryManager sharedInstance] libraryFilepathForCurrentTimestampWithExtension:@"png"];
    
    [[FLIROneSDKStreamManager sharedInstance] capturePhotoWithFilepath:filepath];
}

- (IBAction) captureVideo:(id)sender {
    @synchronized([FLIROneSDKExampleViewController class]) {
        self.cameraBusy = YES;
        if(self.currentlyRecording) {
            //stop recording
            [[FLIROneSDKStreamManager sharedInstance] stopRecordingVideo];
        } else {
            NSURL *filepath = [[FLIROneSDKLibraryManager sharedInstance] libraryFilepathForCurrentTimestampWithExtension:@"mov"];
            [[FLIROneSDKStreamManager sharedInstance] startRecordingVideoWithFilepath:filepath withVideoRendererDelegate:self];
        }
        
        [self updateUI];
    }
}

//callbacks for video recording
- (void) FLIROneSDKDidStartRecordingVideo:(FLIROneSDKCaptureStatus)captureStartStatus {
    if(captureStartStatus == FLIROneSDKCaptureStatusSucceeded) {
        self.currentlyRecording = YES;
    } else {
        self.cameraBusy = NO;
    }
    
    [self updateUI];
}

- (void) FLIROneSDKDidStopRecordingVideo:(FLIROneSDKCaptureStatus)captureStopStatus {
    self.currentlyRecording = NO;
    
    if(captureStopStatus == FLIROneSDKCaptureStatusFailedWithUnknownError) {
        self.cameraBusy = NO;
    }
    
    [self updateUI];
}

- (void) FLIROneSDKDidFinishWritingVideo:(FLIROneSDKCaptureStatus)captureWriteStatus withFilepath:(NSString *)videoFilepath {
    
    self.cameraBusy = NO;
    
    [self updateUI];
}

//grab any valid image delivered from the sled
- (UIImage *)currentImage {
//    UIImage *image = self.radiometricImage;
	UIImage *image = self.thermalImage;

    /*if(!image) {
        image = self.radiometricImage;
    }*/
    if(!image) {
        image = self.thermalImage;
    }

    return image;
}

//callback for rendering video in arbitrary video format
- (UIImage *)imageForFrameAtTimestamp:(CMTime)timestamp {
    NSLog(@"size: %@", NSStringFromCGSize(self.currentImage.size));
    NSLog(@"%d, %lld", timestamp.timescale, timestamp.value);
    NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];
    NSLog(@"uptime: %f", uptime);
    return [self currentImage];
}

@end
