/*
Open source edit of Ryan Petrich's, open source (…), FastBlurredNotificationCenter.

Only change made by me is the option to change colors and enable/ disable blurred background.
*/
NSMutableDictionary* plistDict;


//#import <UIKit/UIKit2.h>
//#import <QuartzCore/QuartzCore2.h>
#import <SpringBoard/SpringBoard.h>
#import <IOSurface/IOSurface.h>

@interface UIImage (IOSurface)
- (id)_initWithIOSurface:(IOSurfaceRef)surface scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
@end

%config(generator=internal)

@interface SBBulletinListView : UIView
+ (UIImage *)linen;
- (UIImageView *)linenView;
- (UIView *)slidingView;
- (void)positionSlidingViewAtY:(CGFloat)y;
@end



%hook SBBulletinListView

UIImage *image;

static UIView *screenView;
static BOOL shouldBlur = NO;
static BOOL enabled = NO;

+ (UIImage *)linen
{
NSString *filePath = @"/var/mobile/Library/Preferences/com.pathkiller.nccolors.plist";
plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
enabled = [[plistDict objectForKey:@"enabled"]boolValue];


	if (enabled){
	return nil;
}else{
return %orig;
}
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
NSString *filePath = @"/var/mobile/Library/Preferences/com.pathkiller.nccolors.plist";
plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];

NSString *red;
NSString *green;
NSString *blue;
red = [plistDict objectForKey:@"R"];
green = [plistDict objectForKey:@"G"];
blue = [plistDict objectForKey:@"B"];
shouldBlur = [[plistDict objectForKey:@"blur"]boolValue];
enabled = [[plistDict objectForKey:@"enabled"]boolValue];


float redValue = [red floatValue];
float greenValue = [green floatValue];
float blueValue = [blue floatValue];

       //blur by ryan petrich 
	if ((self = %orig)) {
if(enabled){
if (shouldBlur) {
		IOSurfaceRef surface = [UIWindow createScreenIOSurface];
		UIImageOrientation imageOrientation;
		switch ([(SpringBoard *)UIApp activeInterfaceOrientation]) {
			case UIInterfaceOrientationPortrait:
			default:
				imageOrientation = UIImageOrientationUp;
				break;
			case UIInterfaceOrientationPortraitUpsideDown:
				imageOrientation = UIImageOrientationDown;
				break;
			case UIInterfaceOrientationLandscapeLeft:
				imageOrientation = UIImageOrientationRight;
				break;
			case UIInterfaceOrientationLandscapeRight:
				imageOrientation = UIImageOrientationLeft;
				break;
		}
		image = [[UIImage alloc] _initWithIOSurface:surface scale:[UIScreen mainScreen].scale orientation:imageOrientation];
		CFRelease(surface);
		if (!screenView)
			screenView = [[UIImageView alloc] initWithImage:image];
		static NSArray *filters;
		if (!filters) {
			CAFilter *filter = [CAFilter filterWithType:@"gaussianBlur"];
			[filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
			filters = [[NSArray alloc] initWithObjects:filter, nil];
		}



        
		CALayer *layer = screenView.layer;
		layer.filters = filters;
		layer.shouldRasterize = YES;
		screenView.alpha = 0.0f;

		[self insertSubview:screenView atIndex:0];

}
		[self linenView].backgroundColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:0.5f];

}
}
	
	return self;
}


- (void)dealloc
{
	[screenView removeFromSuperview];
	[screenView release];
	screenView = nil;
	[plistDict release];
	plistDict = nil;
	[image release];
	image = nil;

	%orig;
}
-(void)positionSlidingViewAtY:(CGFloat)y
{

NSString *filePath = @"/var/mobile/Library/Preferences/com.pathkiller.nccolors.plist";
plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
NSString *red;
NSString *green;
NSString *blue;
red = [plistDict objectForKey:@"R"];
green = [plistDict objectForKey:@"G"];
blue = [plistDict objectForKey:@"B"];
shouldBlur = [[plistDict objectForKey:@"blur"]boolValue];


float redValue = [red floatValue];
float greenValue = [green floatValue];
float blueValue = [blue floatValue];
        	CGFloat height = self.bounds.size.height;

        if (shouldBlur) {

	screenView.alpha = height ? (y / height) : 1.0f;
    //screenView.center = CGPointMake( self.bounds.origin.x + 160, y + (height/2));
   // screenView.alpha = 1.0f;
}
		[self linenView].backgroundColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:height ? ((y / height)/2) : .5f];

	%orig;
}

%end
