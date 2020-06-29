//
//  UIUnitLabel.h
//
//  Created by Hanno Rein on 4/28/13.
//
//
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#define UILabel NSTextField
#define UIColor NSColor
#define UIView NSView
#define UIFont NSFont
#define NSTextAlignmentRight 1
#endif
#import "floate.h"

//IB_DESIGNABLE
@interface UIScientificNotationLabel : UIView{
	
}

@property(nonatomic) NSTextAlignment textAlignment; // Only right aligment is currently supported.
@property(strong,nonatomic) UIColor* textColor;
-(void)setFontSize:(float)fs;
-(void)setText:(NSString*)newText;	// Sets a simple text (without scientific notation)
-(NSString*)getText;
-(void)setFloatE:(floate)floatE;
-(void)setFloatE:(floate)value unit:(NSString*)unit; // Sets the value and the units of the label.
-(void)setFloatE:(floate)value unit:(NSString*)unit hideErrors:(bool)showErrors;

-(void)setDoubleE:(doublee)value unit:(NSString*)unit hideErrors:(bool)showErrors;

@end
