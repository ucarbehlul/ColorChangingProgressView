//
//  BarProgressView.h
//  BarProgressView
//
//	modified by behlul ucar
//	based on initial work of jonathan king 


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define defaultWidthOfBar 1 //Default width in pixels, which can be changed with the 'widthOfBar' property.
#define defaultSpaceBetweenBars 0.0 //Space in pixels between the bars, edit this constant to change the width.

#define defaultCompleteBarStartColor [UIColor orangeColor]
#define defaultCompleteBarEndColor [UIColor greenColor]
#define defaultEmptyBarFillColor [UIColor colorWithRed:101.0/255.0f green:105.0/255.0f blue:87.0/255.0f alpha:1] //The color the bars will be when they are 'empty'

@interface ColorChangingBarProgressView : UIView {}

@property (nonatomic) int widthOfBar;
@property (nonatomic) float progress;

@property (nonatomic, retain) UIColor* completeBarStartColor;
@property (nonatomic, retain) UIColor* completeBarEndColor;
@property (nonatomic, retain) UIColor *emptyBarFillColor;

@end
