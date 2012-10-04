//  BarProgressView.m
//  BarProgressView
//
//	modified by behlul ucar
//	based on initial work of jonathan king 

#import "ColorChangingBarProgressView.h"

@interface ColorChangingBarProgressView() {
    
    //The layer which will contain the bars
    CALayer *progressLayer;
    int totalNumberOfBars;
}

// Private method which calculates how many bars should be drawn
- (int)numberOfBarsForWidth:(CGFloat)width;
// Private method which calculates how much left over space ther will be, as the bars width might not exactly qual the screen width, so padding on either side may be necesssary.
- (float)remainderFromBarsInWidth:(CGFloat)width;

// Private methods which create the bars
- (CALayer *)completeBarLayerOfSize:(CGRect)size color:(UIColor*)color;
- (CALayer *)emptyBarLayerOfSize:(CGRect)size;
@end

@implementation ColorChangingBarProgressView

@synthesize progress = _progress;
@synthesize widthOfBar = _widthOfBar;
@synthesize completeBarStartColor, completeBarEndColor, emptyBarFillColor;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    	[self doInit];
    }
    return self;
}

-(id)init {
    if (self = [super init]) {
		[self doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
		[self doInit];
    }
    return self;
}

-(void)doInit {
    self.backgroundColor = [UIColor clearColor];
    
    //Set the fill colors to the default values
    self.completeBarStartColor = defaultCompleteBarStartColor;
    self.completeBarEndColor = defaultCompleteBarEndColor;
    self.emptyBarFillColor = defaultEmptyBarFillColor;
    
    //Set the default width of the bars.
    self.widthOfBar = defaultWidthOfBar;
	self.progress = 0;
}


- (void) drawRect:(CGRect)rect
{
	[super drawRect:rect];

	// Drawing clear background.
//	[[UIColor clearColor] set];
//	UIRectFill(rect);
	
	//Create containing layer for the bars.
	progressLayer = [CALayer layer];
	[progressLayer setFrame:rect];
    [progressLayer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor]];
	[self.layer addSublayer:progressLayer];
}

- (void)layoutSubviews {
    
    //As the width may have changed, 
    
    //When the height or width of the frame is changed, the bars are redrawn.
    [self redrawBars];
}

- (void)redrawBars {
    
//    //Information about the bars being drawn
//    int remainder = [self remainderFromBarsForWidth:self.frame.size.width];
//    NSLog(@"Total number of bars: %d - With a padding of %d", totalNumberOfBars, remainder);
    
    float progress = _progress;
    totalNumberOfBars = [self numberOfBarsForWidth:self.frame.size.width];
    
    int numberOfCompleteBars = totalNumberOfBars * progress;
    float remainderOfWidth = [self remainderFromBarsInWidth:self.frame.size.width]/2.0f;
    
    progressLayer.sublayers = nil; //Remove all the sublayers
    
    for (int i = 0; i < numberOfCompleteBars ; i++) {
        
        float XPositionForBar = (_widthOfBar*i + defaultSpaceBetweenBars*(i-1))+remainderOfWidth;
        float heightForBar = self.frame.size.height;
        
        CGFloat sHue, sSat, sBright, sAlpha;
        CGFloat eHue, eSat, eBright, eAlpha;
        [self.completeBarStartColor getHue:&sHue saturation:&sSat brightness:&sBright alpha:&sAlpha];
        [self.completeBarEndColor getHue:&eHue saturation:&eSat brightness:&eBright alpha:&eAlpha];
        UIColor* barColor = [UIColor colorWithHue:sHue + (eHue-sHue)*((float)i/totalNumberOfBars) saturation:sSat brightness:sBright alpha:sAlpha];
        [progressLayer addSublayer:[self completeBarLayerOfSize:
                CGRectMake(XPositionForBar, 0, _widthOfBar, heightForBar)
                color:barColor]];
    }
    
    for (int i = numberOfCompleteBars; i < totalNumberOfBars ; i++) {
        
        float XPositionForBar = (_widthOfBar*i + defaultSpaceBetweenBars*(i-1))+remainderOfWidth;
        float heightForBar = self.frame.size.height;
        
        [progressLayer addSublayer:[self emptyBarLayerOfSize:CGRectMake(XPositionForBar, 0, _widthOfBar, heightForBar)]];
    }
}

#pragma mark Setting Atrributes

- (void)setProgress:(float)progress {
    
    float currentProgress = _progress;
    float futureProgress = progress;
    
    //If progress is greater than 1, make it equal 1 - Failsafe, which stops crashing.
    if(progress<=1) _progress = progress;
    else _progress = 1;
    
    //Work out the current number of complete bars as integers, and compare this number to that with the future number of complete bars. If the two numbers are different redraw the nars, otherwise do nothing. By doing this, it is saving uneccasary calls for redrawing, and improving performance.
    
    int currentNumberOfCompleteBars = totalNumberOfBars * currentProgress;
    int futureNumberOfCompleteBars = totalNumberOfBars * futureProgress;
    
    if (currentNumberOfCompleteBars!=futureNumberOfCompleteBars) {
        //Redraw the bars with the new progress data.
        [self redrawBars];
    }
    
}

- (void)setWidthOfBar:(int)widthOfBar {
    
    _widthOfBar = widthOfBar;
    //Redraw the bars with the new width.
    [self redrawBars];
}

#pragma mark Bar Creation

- (CALayer *)completeBarLayerOfSize:(CGRect)size
         color:(UIColor*)color {
    
    CALayer *layer = [CALayer layer];
    layer.frame = size;
    [layer setBackgroundColor:color.CGColor];
    return layer;
}

- (CALayer *)emptyBarLayerOfSize:(CGRect)size {
    
    CALayer *layer = [CALayer layer];
    layer.frame = size;
    [layer setBackgroundColor:[emptyBarFillColor CGColor]];
    return layer;
}

#pragma mark Bar Logic

- (int)numberOfBarsForWidth:(CGFloat)width {
    
    int numberOfBars; numberOfBars = 1;
    
    while ((_widthOfBar*numberOfBars + defaultSpaceBetweenBars*(numberOfBars-1)) <= width) {
        numberOfBars ++;
    }
    
    return numberOfBars - 1; //As the while statment stops when numberOfBars is greater, the number - 1 would be the last possible value.
}

- (float)remainderFromBarsInWidth:(CGFloat)width {
    
    CGFloat totalWidthOfProgressBar; totalWidthOfProgressBar = _widthOfBar*totalNumberOfBars + defaultSpaceBetweenBars*(totalNumberOfBars-1);
    return width - totalWidthOfProgressBar;
}

- (void)dealloc {
	[progressLayer removeAllAnimations];
	[progressLayer removeFromSuperlayer];
}


@end
