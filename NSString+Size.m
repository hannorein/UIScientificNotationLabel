//
//  NSString+Size.m
//  Exoplanet
//
//  Created by Hanno Rein on 5/13/13.
//  Copyright (c) 2013 Hanno Rein. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

-(NSSize)sizeWithFont:(NSFont*)font{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    NSAttributedString* attribString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    NSSize size = [attribString size];
    [attribString release];
    return size;
}
-(void)drawAtPoint:(CGPoint)point withFont:(NSFont*)font{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSColor whiteColor], NSForegroundColorAttributeName, nil];
    [self drawAtPoint:point withAttributes:attributes];
}
@end
