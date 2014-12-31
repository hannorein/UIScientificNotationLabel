//
//  NSString+Size.m
//  Exoplanet
//
//  Created by Hanno Rein on 5/13/13.
//  Copyright (c) 2013 Hanno Rein. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)


-(float)widthWithFont:(UIFont *)font{
	return ceilf([self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
								   options:nil
								attributes:@{NSFontAttributeName: font}
								   context:nil].size.width);
}

@end
