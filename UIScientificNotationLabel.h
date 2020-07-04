//
//  UIUnitLabel.h
//
//  Created by Hanno Rein on 4/28/13.
//
//
#import <UIKit/UIKit.h>
#import "floate.h"


@interface UIScientificNotationLabel : UIView{
	
}

@property (strong,nonatomic) NSNumber* fontSize;
@property(strong,nonatomic) UIColor* textColor;
-(void)setText:(NSString*)newText;	// Sets a simple text (without scientific notation)
-(NSString*)getText;
-(void)setFloatE:(floate)floatE;
-(void)setFloatE:(floate)value unit:(NSString*)unit; // Sets the value and the units of the label.
-(void)setFloatE:(floate)value unit:(NSString*)unit hideErrors:(bool)showErrors;

-(void)setDoubleE:(doublee)value unit:(NSString*)unit hideErrors:(bool)showErrors;

@end
