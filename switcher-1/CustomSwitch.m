//
//  CustomSwitch.m
//

#import "CustomSwitch.h"


static const CGFloat kSlideOffValue = 0.0;
static const CGFloat kSlideOnValue = 1.0;
static CGFloat Threshold = ((kSlideOnValue - kSlideOffValue) / 2);

static CGFloat kThumbSideMargin = 4.0f;

@interface CustomSwitch ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *thumbONImage;
@property (strong, nonatomic) UIImage *thumbOFFImage;
@property (assign, nonatomic, getter = isDragged) BOOL dragged;

@end


@implementation CustomSwitch

- (id)initWithFrame:(CGRect)rect
{
	if (self = [super initWithFrame:rect])
	{
		[self initViews];
	}
	return self;
}

- (void)initViews
{
	self.backgroundColor = [UIColor clearColor];
    
    UIImage *clearImage = [UIImage imageNamed:@"clear"];
    [self setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    
    [self addSubview:self.backgroundImageView];
	
	self.minimumValue = kSlideOffValue;
	self.maximumValue = kSlideOnValue;
	
	self.on = NO;
    
    [self addTarget:self action:@selector(dragInside) forControlEvents:UIControlEventTouchDragInside];
}

#pragma mark - User Interaction Logic

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self touchUp];
}

- (void)dragInside
{
    self.dragged = YES;
    [self updateThumbImageForState:[self isSwitchedONForValue:self.value]];
}

- (void)touchUp
{
    if ([self isDragged] == NO)
    {
        self.on = !self.on;
    }
    else
    {
        self.on = [self isSwitchedONForValue:self.value];
        self.dragged = NO;
    }
}

- (BOOL)isSwitchedONForValue:(CGFloat)value
{
    BOOL result = (value > Threshold);
    return result;
}

#pragma mark - Set On

- (void)setOn:(BOOL)turnOn
{
	[self setOn:turnOn animated:YES];
}

- (void)setOn:(BOOL)turnOn animated:(BOOL)animated;
{
	_on = turnOn;
	
    [self setValue:_on ? kSlideOnValue : kSlideOffValue animated:animated];
    [self updateThumbImageForState:_on];
}

#pragma mark - Update Thumb Image

- (void)updateThumbImageForState:(BOOL)switchedOn
{
    if (switchedOn)
    {
        [self setThumbImage:self.thumbONImage forState:UIControlStateNormal];
    }
    else
    {
        [self setThumbImage:self.thumbOFFImage forState:UIControlStateNormal];
    }
}

#pragma mark - Calculate Track Rect

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    
    CGRect result = bounds;
    result.origin.x = kThumbSideMargin;
    result.size.width -= kThumbSideMargin * 2;
    CGFloat thumbHeight = self.thumbONImage.size.height;
    result.origin.y = floorf((CGRectGetHeight(bounds) - thumbHeight) / 2);
    result.size.height = thumbHeight;
    
    return result;
}

#pragma mark - Rect Calculation Helper

- (CGRect)horizontalCenterAlighnedRectForBounds:(CGRect)bounds andRectHeight:(CGFloat)height
{
    CGRect result = bounds;
    result.origin.y = floorf((CGRectGetHeight(bounds) - height) / 2);
    result.size.height = height;
    return result;
}

#pragma mark - Lazy Loading

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        UIImageView *result = [UIImageView new];
        result.image = self.backgroundImage;
        _backgroundImageView = result;
    }
    
    CGRect resultFrame = [self horizontalCenterAlighnedRectForBounds:self.bounds
                                                       andRectHeight:_backgroundImageView.image.size.height];
    _backgroundImageView.frame = resultFrame;
    return _backgroundImageView;
}

- (UIImage *)backgroundImage
{
    if (_backgroundImage == nil)
    {
        _backgroundImage = [[UIImage imageNamed:@"RM-switch-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 25)
                                                                                        resizingMode:UIImageResizingModeTile];
    }
    return _backgroundImage;
}

- (UIImage *)thumbONImage
{
    if (_thumbONImage == nil)
    {
        _thumbONImage = [UIImage imageNamed:@"RM-switch-thumb-on"] ;
    }
    return _thumbONImage;
}

- (UIImage *)thumbOFFImage
{
    if (_thumbOFFImage == nil)
    {
        _thumbOFFImage = [UIImage imageNamed:@"RM-switch-thumb-off"] ;
    }
    return _thumbOFFImage;
}

@end
