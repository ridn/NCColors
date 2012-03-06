/*
Open source edit of Ryan Petrich's, open source (…), FastBlurredNotificationCenter.

Only change made by me is the option to change colors and enable/ disable blurred background.
*/



#import <UIKit/UIKit2.h>
#import <QuartzCore/QuartzCore2.h>
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

static BOOL enabled;
static BOOL blur;

static float blue;
static float red;
static float green;

static UIView *activeView;

static void loadPrefs()
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.pathkiller.nccolors.plist"];
	enabled = [[dict objectForKey:@"enabled"] boolValue];
	blue = [[dict objectForKey:@"B"] floatValue];
	red = [[dict objectForKey:@"R"] floatValue];
	green = [[dict objectForKey:@"G"] floatValue];
	blur = [[dict objectForKey:@"blur"] boolValue];
	[dict release];
}

%hook SBBulletinListView

+ (UIImage *)linen
{
	if (enabled) {
		return nil;
	} else { return %orig; }
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
	if ((self = %orig)) {
	if (enabled) {
		if (blur) {
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
			UIImage *image = [[UIImage alloc] _initWithIOSurface:surface scale:[UIScreen mainScreen].scale orientation:imageOrientation];
			CFRelease(surface);
			if (!activeView)
				activeView = [[UIImageView alloc] initWithImage:image];
			static NSArray *filters;
			if (!filters) {
				CAFilter *filter = [CAFilter filterWithType:@"gaussianBlur"];
				[filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
				filters = [[NSArray alloc] initWithObjects:filter, nil];
			}
			CALayer *layer = activeView.layer;
			layer.filters = filters;
			layer.shouldRasterize = YES;
			activeView.alpha = 0.0f;
	
			[self insertSubview:activeView atIndex:0];

		}
		[self linenView].backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];

	}
}
	return self;
}


- (void)dealloc
{
	[activeView release];
	activeView = nil;
	%orig;
}
%end

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.pathkiller29.nccolors"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
	[pool drain];
}
