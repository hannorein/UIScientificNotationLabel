//
//  UIUnitLabel.m
//  Exoplanet
//
//  Created by Hanno Rein on 4/28/13.
//
//

#import "UIScientificNotationLabel.h"
#import "NSString+Size.h"

@interface UIScientificNotationLabel(){
	UIFont* largeFont;
	UIFont* smallFont;
	
	NSString*	exp0String;
	NSString*	exp1String;
	NSString*	exp2String;
	NSString*	errorString;
	NSString*	errorMinusString;
	NSString*	errorPlusString;
	NSString*	dataString;
	NSString*	unitString;
	UIColor*	textColor;
}
@end

@implementation UIScientificNotationLabel
@synthesize textColor;


-(id)initWithCoder:(NSCoder *)aDecoder{
	if (self=[super initWithCoder:aDecoder]){
		self.textAlignment		= NSTextAlignmentRight;
		self.contentMode		= UIViewContentModeRedraw;
		self.textColor			= [UIColor whiteColor];
        [self setFontSize:11];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame{
	if (self=[super initWithFrame:frame]){
		self.textAlignment		= NSTextAlignmentRight; 
		self.backgroundColor	= [UIColor clearColor];
		self.contentMode		= UIViewContentModeRedraw;
		self.textColor			= [UIColor whiteColor];
        [self setFontSize:17];
	}
	return self;
}
-(void)setFontSize:(float)fs{
    largeFont = [UIFont systemFontOfSize:fs];
    smallFont = [UIFont systemFontOfSize:fs/1.7];
}


-(void)setTextColor:(UIColor *)newTextColor{
	textColor = newTextColor;
}

-(void)setText:(NSString *)newText{
	unitString = nil;
	errorString = nil;
	errorMinusString = nil;
	errorPlusString = nil;
	exp0String = nil;
	exp1String = nil;
	exp2String = nil;
	
	dataString = newText;
	[self setNeedsLayout];
	[self setNeedsDisplay];
}
-(NSString*)getText{
	return dataString;
}
-(void)setFloatE:(floate)value{
	[self setFloatE:value unit:nil hideErrors:NO];
}
-(void)setFloatE:(floate)value unit:(NSString *)unit{
	[self setFloatE:value unit:unit hideErrors:NO];
}

-(float)drawString:(NSString*)string atPoint:(CGPoint)point withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes{
	CGRect br = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
								   options:NSStringDrawingUsesDeviceMetrics
								attributes:attributes
								   context:nil];
	float width = ceilf(br.size.width);
	[string drawAtPoint:CGPointMake(point.x-width, point.y)  withAttributes:attributes];
	return width;
}

-(void)drawRect:(CGRect)rect{
	float spaceWidth = [@"a b" widthWithFont:largeFont]-[@"ab" widthWithFont:largeFont];
	
	float basePosY = (self.frame.size.height-largeFont.lineHeight)/2.;
	float basePosYPlus = basePosY + largeFont.ascender -smallFont.ascender - largeFont.capHeight/1.7;
	float basePosYMinus = basePosY + largeFont.ascender -smallFont.ascender + largeFont.capHeight/4. ;
    
	NSDictionary *largeFontAttributes = @{NSFontAttributeName: largeFont, NSForegroundColorAttributeName: textColor};
	NSDictionary *smallFontAttributes = @{NSFontAttributeName: smallFont, NSForegroundColorAttributeName: textColor};
	
	float currentx = self.frame.size.width-1; // -1 to avoid clipping (or could change ceil to floor in first call)
	if ([unitString length]){
		currentx -= [self drawString:unitString atPoint:CGPointMake(currentx, basePosY) withAttributes:largeFontAttributes];
		currentx -= spaceWidth;
	}
	if ([exp2String length]){
		currentx -= [self drawString:exp2String atPoint:CGPointMake(currentx, basePosYPlus) withAttributes:smallFontAttributes];
		currentx -= spaceWidth*0.15; // just a little more space for appearance
	}
	if ([exp1String length]){
		currentx -= [self drawString:exp1String atPoint:CGPointMake(currentx, basePosY) withAttributes:largeFontAttributes];
		currentx -= spaceWidth;
	}
	if ([errorString length]){
		currentx -= [self drawString:errorString atPoint:CGPointMake(currentx, basePosY) withAttributes:largeFontAttributes];
	}else{
		float exp_width = 0;
		if ([errorPlusString length]){
			exp_width = MAX(exp_width,[self drawString:errorPlusString atPoint:CGPointMake(currentx, basePosYPlus) withAttributes:smallFontAttributes]);
		}
		if ([errorMinusString length]){
			exp_width = MAX(exp_width,[self drawString:errorMinusString atPoint:CGPointMake(currentx, basePosYMinus) withAttributes:smallFontAttributes]);
		}
		if (exp_width>0.){
			currentx -= exp_width;
			currentx -= spaceWidth*0.25; // just a little more space for appearance
		}
	}
	if ([dataString length]){
		currentx -= [self drawString:dataString atPoint:CGPointMake(currentx, basePosY) withAttributes:largeFontAttributes];
	}
	if ([exp0String length]){
		currentx -= [self drawString:exp0String atPoint:CGPointMake(currentx, basePosY) withAttributes:largeFontAttributes];
	}
}
	
-(void)setDoubleE:(doublee)value unit:(NSString *)unit hideErrors:(bool)hideErrors{
	floate f = {.value = value.value, .upperlimit = value.upperlimit, .lowerlimit = value.lowerlimit, .error_plus = value.error_plus, .error_minus = value.error_minus};
	[self setFloatE:f unit:unit hideErrors:hideErrors];
}


-(void)setFloatE:(floate)value unit:(NSString *)unit hideErrors:(bool)hideErrors{
	bool isExp = YES;
	int exponent;
	double dexponent;
	if (!isnan(value.value)){
		exponent = floor(log10(value.value));
		dexponent = pow(10, exponent);
	}else if (!isnan(value.upperlimit)){
		exponent = floor(log10(value.upperlimit));
		dexponent = pow(10, exponent);
	}else if (!isnan(value.lowerlimit)){
		exponent = floor(log10(value.lowerlimit));
		dexponent = pow(10, exponent);
	}else{
		[self setText:@"N/A"];
		return;
	}
	
	if ((exponent>-4 && exponent<5) || (!isnan(value.value) && value.value<=0.) ){
		isExp = NO;
	}else{
		const double diexponent = 1./dexponent;
		value.value			*=diexponent;
		value.error_minus	*=diexponent;
		value.error_plus	*=diexponent;
		value.upperlimit	*=diexponent;
		value.lowerlimit	*=diexponent;
	}

	int significantdigits = 2;
	if (!isnan(value.value)){
		significantdigits = -floor(log10(fabs(value.value/2.f)));
		if (!isnan(value.error_plus) && !isnan(value.error_minus)){
			int error_significantdigits = MAX(-floor(log10(value.error_plus/2.)),-floor(log10(value.error_minus/2.)));
			significantdigits = MAX(error_significantdigits,significantdigits);
		}else{
			significantdigits +=2;
		}
	}else{
		//upper/lower limits
		significantdigits = 4;
	}
	significantdigits = MIN(significantdigits,4.);
	significantdigits = MAX(significantdigits,0.);

	bool hasErrors = NO;
	if ((!isnan(value.error_plus) || !isnan(value.error_minus)) && !hideErrors) hasErrors = YES;
	
	NSString* formatString = [NSString stringWithFormat:@"%%.%df",significantdigits];

	if (!isnan(value.value)){
		dataString = [NSString localizedStringWithFormat:formatString, value.value];
	}else{
		if (!isnan(value.lowerlimit)){
			dataString = [NSString localizedStringWithFormat:[NSString stringWithFormat:@"> %@",formatString], value.lowerlimit];
		}else if (!isnan(value.upperlimit)){
			dataString = [NSString localizedStringWithFormat:[NSString stringWithFormat:@"< %@",formatString], value.upperlimit];
		}
	}
	
	if (self.textAlignment==NSTextAlignmentRight) {
		unitString = unit;
		if (isExp){
			exp2String = [NSString stringWithFormat:@"%d",exponent];
			if (hasErrors){
				exp1String = @")⋅10";
			}else{
				exp1String = @"⋅10";
			}
		}else{
			exp1String = nil;
			exp2String = nil;
		}

		if (hasErrors){
			if (!isnan(value.error_minus)){
				errorMinusString = [NSString localizedStringWithFormat:[NSString stringWithFormat:@"−%@",formatString],value.error_minus];
			}else{
				errorMinusString = nil;
			}
			if (!isnan(value.error_plus)){
				errorPlusString = [NSString localizedStringWithFormat:[NSString stringWithFormat:@"+%@",formatString],value.error_plus];
			}else{
				errorPlusString = nil;
			}
			if (!isnan(value.error_minus)&&!isnan(value.error_minus)
				&& [[errorMinusString substringFromIndex:1] isEqualToString:[errorPlusString substringFromIndex:1]]){
				errorString = [NSString localizedStringWithFormat:[NSString stringWithFormat:@"± %@",formatString],value.error_plus];
				errorMinusString = nil;
				errorPlusString = nil;
			}else{
				errorString = nil;
			}
		}else{
			errorString			= nil;
			errorMinusString	= nil;
			errorPlusString		= nil;
		}
		if (isExp && hasErrors){
			exp0String = @"( ";
		}else{
			exp0String = nil;
		}
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}


@end
