//
//  UIUnitLabel.m
//  Exoplanet
//
//  Created by Hanno Rein on 4/28/13.
//
//

#import "UIScientificNotationLabel.h"
#import "NSString+Size.h"

@implementation UIScientificNotationLabel
@synthesize textColor;

-(id)initWithCoder:(NSCoder *)aDecoder{
	if (self=[super initWithCoder:aDecoder]){
		self.textAlignment		= NSTextAlignmentRight;
#if TARGET_OS_IPHONE
		self.contentMode		= UIViewContentModeRedraw;
#endif
		self.textColor			= [UIColor whiteColor];
        [self setFontSize:11];
	}
	return self;
}
-(id)initWithFrame:(CGRect)frame{
	if (self=[super initWithFrame:frame]){
		self.textAlignment		= NSTextAlignmentRight; 
#if TARGET_OS_IPHONE
		self.backgroundColor	= [UIColor clearColor];
		self.contentMode		= UIViewContentModeRedraw;
#endif
		self.textColor			= [UIColor whiteColor];
        [self setFontSize:17];
	}
	return self;
}
-(void)setFontSize:(float)fs{
    [largeFont release];
    [smallFont release];
    largeFont = [[UIFont systemFontOfSize:fs] retain];
    smallFont = [[UIFont systemFontOfSize:fs/1.7] retain];
}

-(void)dealloc{
	[unitString release];
	[dataString release];
	[errorString release];
	[errorMinusString release];
	[errorPlusString release];
	[exp0String release];
	[exp1String release];
	[exp2String release];
	[textColor release];
    [largeFont release];
    [smallFont release];
	[super dealloc];
}

-(void)setTextColor:(UIColor *)newTextColor{
	[textColor release];
	textColor = [newTextColor retain];
}

-(void)setText:(NSString *)newText{
	[unitString release];
	unitString = nil;
	[errorString release];
	errorString = nil;
	[errorMinusString release];
	errorMinusString = nil;
	[errorPlusString release];
	errorPlusString = nil;
	[exp0String release];
	exp0String = nil;
	[exp1String release];
	exp1String = nil;
	[exp2String release];
	exp2String = nil;
	
	[dataString release];
	dataString = [newText retain];
#if TARGET_OS_IPHONE
	[self setNeedsLayout];
	[self setNeedsDisplay];
#else
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
#endif
    
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
#if !(TARGET_OS_IPHONE)
-(void)layoutSublayersOfLayer:(CALayer *)layer{
#else
-(void)layoutSubviews{
#endif
	float spaceWidth = [@" " widthWithFont:largeFont];

	if (self.textAlignment==NSTextAlignmentRight) {
		float posX = self.frame.size.width;
		
		float unitWidth			= [unitString widthWithFont:largeFont];
		posX -= unitWidth;
		unitPosX = posX;
		
		if (unitWidth>0){
			posX -= spaceWidth;
		}
		
		float exp2width			= [exp2String widthWithFont:smallFont];
		posX -= exp2width;
		exp2PosX = posX;
		
		float exp1width			= [exp1String widthWithFont:largeFont];
		posX -= exp1width;
		exp1PosX = posX;
		
		float errorWidth		= [errorString widthWithFont:largeFont];
		float errorMinusWidth	= [errorMinusString widthWithFont:smallFont];
		float errorPlusWidth	= [errorPlusString widthWithFont:largeFont];

		posX -= MAX(MAX(errorMinusWidth,errorPlusWidth),errorWidth);
		errorPosX = posX;
		
		float dataWidth			= [dataString widthWithFont:largeFont];
		posX -= dataWidth;
		dataPosX = posX;
		
		float exp0width			= [exp0String widthWithFont:largeFont];
		posX -= exp0width;
		exp0PosX = posX;
		
	}
}

-(void)drawRect:(CGRect)rect{
	float basePosY = (self.frame.size.height-largeFont.lineHeight)/2.;
	float basePosYPlus = basePosY + largeFont.ascender -smallFont.ascender - largeFont.capHeight/1.7;
	float basePosYMinus = basePosY + largeFont.ascender -smallFont.ascender + largeFont.capHeight/4. ;
    
	NSDictionary *largeFontAttributes = @{NSFontAttributeName: largeFont, NSForegroundColorAttributeName: textColor};
	NSDictionary *smallFontAttributes = @{NSFontAttributeName: smallFont, NSForegroundColorAttributeName: textColor};
	
	[unitString drawAtPoint:CGPointMake(unitPosX, basePosY)  withAttributes:largeFontAttributes];
	[dataString drawAtPoint:CGPointMake(dataPosX, basePosY) withAttributes:largeFontAttributes];
	[errorString drawAtPoint:CGPointMake(errorPosX, basePosY) withAttributes:largeFontAttributes];
	[errorPlusString drawAtPoint:CGPointMake(errorPosX, basePosYPlus) withAttributes:smallFontAttributes];
	[errorMinusString drawAtPoint:CGPointMake(errorPosX, basePosYMinus) withAttributes:smallFontAttributes];
	[exp0String drawAtPoint:CGPointMake(exp0PosX, basePosY) withAttributes:largeFontAttributes];
	[exp1String drawAtPoint:CGPointMake(exp1PosX, basePosY) withAttributes:largeFontAttributes];
	[exp2String drawAtPoint:CGPointMake(exp2PosX, basePosYPlus) withAttributes:smallFontAttributes];
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
		dataString = [[NSString localizedStringWithFormat:formatString, value.value] retain];
	}else{
		if (!isnan(value.lowerlimit)){
			dataString = [[NSString localizedStringWithFormat:[NSString stringWithFormat:@"> %@",formatString], value.lowerlimit] retain];
		}else if (!isnan(value.upperlimit)){
			dataString = [[NSString localizedStringWithFormat:[NSString stringWithFormat:@"< %@",formatString], value.upperlimit] retain];
		}
	}
	
	if (self.textAlignment==NSTextAlignmentRight) {

		[unitString release];
		if (unit){
			unitString = [unit retain];
		}else{
			unitString = nil;
		}
		
		[exp1String release];
		[exp2String release];
		if (isExp){
			exp2String = [[NSString stringWithFormat:@"%d",exponent] retain];
			if (hasErrors){
				exp1String = [@" )⋅10" retain];
			}else{
				exp1String = [@" ⋅10" retain];
			}
		}else{
			exp1String = nil;
			exp2String = nil;
		}

		[errorMinusString release];
		[errorPlusString release];
		if (hasErrors){
			if (!isnan(value.error_minus)){
				errorMinusString = [[NSString localizedStringWithFormat:[NSString stringWithFormat:@"−%@",formatString],value.error_minus] retain];
			}else{
				errorMinusString = nil;
			}
			if (!isnan(value.error_plus)){
				errorPlusString = [[NSString localizedStringWithFormat:[NSString stringWithFormat:@"+%@",formatString],value.error_plus] retain];
			}else{
				errorPlusString = nil;
			}
			if (!isnan(value.error_minus)&&!isnan(value.error_minus)
				&& [[errorMinusString substringFromIndex:1] isEqualToString:[errorPlusString substringFromIndex:1]]){
				[errorString release];
				errorString = [[NSString localizedStringWithFormat:[NSString stringWithFormat:@"± %@",formatString],value.error_plus] retain];
				[errorMinusString release];
				errorMinusString = nil;
				[errorPlusString release];
				errorPlusString = nil;
			}else{
				[errorString release];
				errorString = nil;
			}
			
		}else{
			errorString			= nil;
			errorMinusString	= nil;
			errorPlusString		= nil;
		}

		[exp0String release];
		if (isExp && hasErrors){
			exp0String = [@"( " retain];
		}else{
			exp0String = nil;
		}
	}
#if TARGET_OS_IPHONE
	[self setNeedsLayout];
	[self setNeedsDisplay];
#else
	[self setNeedsLayout:YES];
	[self setNeedsDisplay:YES];
#endif
}


@end
