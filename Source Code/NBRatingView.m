//
//  NBRatingView.m
//  IRCTC SMS Booking
//
//  Created by Nanda Ballabh on 03/09/13.
//  Copyright (c) 2013 Monocept. All rights reserved.
//

#import "NBRatingView.h"

static const NSInteger nMinimumRating = 0;
static const NSInteger nMaximumRating = 5;


@interface NBRatingView()

@property (strong) NSMutableArray *imageViews;
@property (assign) NSInteger previousNumber;

@end

@implementation NBRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self defaultInit];
    }
    return self;
}
-(void)defaultInit
{
    _ratingNumber = nMinimumRating;
	_previousNumber = nMinimumRating;
	_imageViews = [NSMutableArray array];
	for (NSInteger viewIndex = 0; viewIndex < nMaximumRating; viewIndex++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewIndex * 42 + 10), 14, 24, 22)];
        [self.imageViews addObject:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        // remove seperator view
//		if (viewIndex > 0) {
//			UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(viewIndex * 42 - 7, 15, 1, 20)];
//			separatorView.image = [UIImage imageNamed:@"text_field_sep"];
//			[self addSubview:separatorView];
//		}
    }
}

- (void)refresh
{
//    for (NSInteger viewIndex = 0; viewIndex < self.imageViews.count; viewIndex++) {
//        UIImageView *imageView = [self.imageViews objectAtIndex:viewIndex];
//        imageView.highlighted = (self.ratingNumber >= viewIndex + 1);
//    }
 // only highlighted
    for (NSInteger viewIndex = 0; viewIndex < self.imageViews.count; viewIndex++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:viewIndex];
        imageView.highlighted = (viewIndex == self.ratingNumber - 1);
    }

}

- (void)setDefaultImageName:(NSString *)defaultImageName
{
	_defaultImageName = defaultImageName;
	for (NSInteger viewIndex = 0; viewIndex < self.imageViews.count; viewIndex++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:viewIndex];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d_off",defaultImageName,viewIndex]];
        imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d_on", defaultImageName,viewIndex]];
    }
	[self refresh];
}

- (void)setRatingNumber:(NSInteger)ratingNumber
{
	_ratingNumber = ratingNumber;
	[self refresh];
}

-(void)handleTouchAtLocation:(CGPoint)point
{
    NSInteger newRating = 0;
    for (NSInteger viewIndex = self.imageViews.count - 1; viewIndex >= 0; viewIndex--)
    {
        UIImageView *imageView = [self.imageViews objectAtIndex:viewIndex];
        if (point.x > imageView.frame.origin.x) {
            newRating = viewIndex + 1;
            break;
        }
    }
	// Must stay at least at the first level.
	if (newRating < nMinimumRating)
		newRating = nMinimumRating;
    self.ratingNumber = newRating;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.previousNumber = self.ratingNumber;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.ratingNumber != self.previousNumber) {
		[self.delegate nbRatingView:self ratingDidChange:self.ratingNumber];
	}
}
@end