//
// Moroku iOS Forms library
// Copyright (C) 2012 Moroku Pty Ltd.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//


#import "SignatureView.h"

@implementation SignatureView

@synthesize context,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




-(void)awakeFromNib {
    
    CGRect bnds = [self bounds];

    
    CGColorSpaceRef colorSpace;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    float pixelsWide = bnds.size.width;
    float pixelsHigh = bnds.size.height;
    
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    
    // Should be monochrome but its a pain to work out the right settings!
    colorSpace = CGColorSpaceCreateDeviceRGB();// 2
 /*   bitmapData = calloc( bitmapByteCount );// 3
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }*/
    context = CGBitmapContextCreate (NULL,// 4
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);

    CGContextSetRGBStrokeColor(context,0.0,0.0,0.0,1.0);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    
    CGContextRef lct = UIGraphicsGetCurrentContext();
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextDrawImage(lct, rect, cgImage);
 
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2, 2)];
    [[UIColor blackColor] setStroke];
    [path stroke];  
    
}

-(void)clear {
    CGContextAddRect(context, [self bounds]);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self];
    [self.nextResponder touchesBegan:touches withEvent:event];

 /*   if ([delegate respondsToSelector:@selector(touchStarted)]) {
        [delegate touchStarted];
    }*/
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint nextPoint = [touch locationInView:self];



    CGContextBeginPath (context);
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
    CGContextStrokePath(context);
        
    lastPoint = nextPoint;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint nextPoint = [touch locationInView:self];

    CGContextBeginPath (context);
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
    CGContextStrokePath(context);
    
    [self setNeedsDisplay];
    [self.nextResponder touchesEnded:touches withEvent:event];

}

-(void)dealloc {
    if(delegate)
        [delegate release];
    [super dealloc];
}
@end
