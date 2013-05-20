//
//  UIUnitLabel.h
//
//  Created by Hanno Rein on 4/28/13.
//
//
#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#define UILabel NSTextField
#define UIColor NSColor
#define UIView NSView
#define UIFont NSFont
#define NSTextAlignmentRight 1
#endif
#import "floate.h"

@interface UIScientificNotationLabel : UIView{
	UIFont* largeFont;
	UIFont* smallFont;
	
	NSString*	exp0String;
	float		exp0PosX;
	NSString*	exp1String;
	float		exp1PosX;
	NSString*	exp2String;
	float		exp2PosX;
	NSString*	errorString;
	float		errorPosX;
	NSString*	errorMinusString;
	NSString*	errorPlusString;
	NSString*	dataString;
	float		dataPosX;
	NSString*	unitString;
	float		unitPosX;
	UIColor*	textColor;
}
@property(nonatomic) NSTextAlignment textAlignment; // Only right aligment is currently supported.
@property(retain,nonatomic) UIColor* textColor;
-(void)setFontSize:(float)fs;
-(void)setText:(NSString*)newText;	// Sets a simple text (without scientific notation)
-(NSString*)getText;
-(void)setFloatE:(floate)floatE;
-(void)setFloatE:(floate)value unit:(NSString*)unit; // Sets the value and the units of the label.
-(void)setFloatE:(floate)value unit:(NSString*)unit hideErrors:(bool)showErrors;
@end
