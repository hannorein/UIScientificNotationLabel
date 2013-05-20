//
//  NSString+Size.h
//  Exoplanet
//
//  Created by Hanno Rein on 5/13/13.
//  Copyright (c) 2013 Hanno Rein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
-(NSSize)sizeWithFont:(NSFont*)font;
-(void)drawAtPoint:(CGPoint)point withFont:(NSFont*)font;
@end