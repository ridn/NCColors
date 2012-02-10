#line 1 "Tweak.x"
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

#include <substrate.h>
@class SBBulletinListView; 

#line 19 "Tweak.x"


static UIView *activeView;


static UIImage * (*__ungrouped$meta$SBBulletinListView$linen)(Class, SEL);static UIImage * $_ungrouped$meta$SBBulletinListView$linen(Class self, SEL _cmd) {
	return nil;
}


static id (*__ungrouped$SBBulletinListView$initWithFrame$delegate$)(SBBulletinListView*, SEL, CGRect, id);static id $_ungrouped$SBBulletinListView$initWithFrame$delegate$(SBBulletinListView* self, SEL _cmd, CGRect frame, id delegate) {
	if ((self = __ungrouped$SBBulletinListView$initWithFrame$delegate$(self, _cmd, frame, delegate))) {
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
		[self linenView].backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
	}
	return self;
}



static void (*__ungrouped$SBBulletinListView$dealloc)(SBBulletinListView*, SEL);static void $_ungrouped$SBBulletinListView$dealloc(SBBulletinListView* self, SEL _cmd) {
	[activeView release];
	activeView = nil;
	__ungrouped$SBBulletinListView$dealloc(self, _cmd);
}


static void (*__ungrouped$SBBulletinListView$positionSlidingViewAtY$)(SBBulletinListView*, SEL, CGFloat);static void $_ungrouped$SBBulletinListView$positionSlidingViewAtY$(SBBulletinListView* self, SEL _cmd, CGFloat y) {
	CGFloat height = self.bounds.size.height;
	activeView.alpha = height ? (y / height) : 1.0f;
	__ungrouped$SBBulletinListView$positionSlidingViewAtY$(self, _cmd, y);
}


static __attribute__((constructor)) void _logosLocalInit() { NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; {Class $$SBBulletinListView = objc_getClass("SBBulletinListView"); Class $$meta$SBBulletinListView = object_getClass($$SBBulletinListView); MSHookMessageEx($$meta$SBBulletinListView, @selector(linen), (IMP)&$_ungrouped$meta$SBBulletinListView$linen, (IMP*)&__ungrouped$meta$SBBulletinListView$linen);MSHookMessageEx($$SBBulletinListView, @selector(initWithFrame:delegate:), (IMP)&$_ungrouped$SBBulletinListView$initWithFrame$delegate$, (IMP*)&__ungrouped$SBBulletinListView$initWithFrame$delegate$);MSHookMessageEx($$SBBulletinListView, @selector(dealloc), (IMP)&$_ungrouped$SBBulletinListView$dealloc, (IMP*)&__ungrouped$SBBulletinListView$dealloc);MSHookMessageEx($$SBBulletinListView, @selector(positionSlidingViewAtY:), (IMP)&$_ungrouped$SBBulletinListView$positionSlidingViewAtY$, (IMP*)&__ungrouped$SBBulletinListView$positionSlidingViewAtY$);}  [pool drain]; }
