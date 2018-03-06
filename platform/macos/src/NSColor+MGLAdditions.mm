#import "NSColor+MGLAdditions.h"

#import <Availability.h>

@implementation NSColor (MGLAdditions)

- (mbgl::Color)mgl_color
{
    CGFloat r, g, b, a;

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 101300
    // The Mapbox Style Specification does not specify a color space, but it is
    // assumed to be sRGB for consistency with CSS.
    [[self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]] getRed:&r green:&g blue:&b alpha:&a];
#else
    [[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&r green:&g blue:&b alpha:&a];
#endif

    return { (float)r, (float)g, (float)b, (float)a };
}

+ (NSColor *)mgl_colorWithColor:(mbgl::Color)color
{
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 101300
    return [NSColor colorWithRed:color.r green:color.g blue:color.b alpha:color.a];
#else
    return [NSColor colorWithCalibratedRed:color.r green:color.g blue:color.b alpha:color.a];
#endif
}

- (mbgl::style::PropertyValue<mbgl::Color>)mgl_colorPropertyValue
{
    mbgl::Color color = self.mgl_color;
    return {{ color.r, color.g, color.b, color.a }};
}

@end

@implementation NSExpression (MGLColorAdditions)

+ (NSExpression *)mgl_expressionForRGBComponents:(NSArray<NSExpression *> *)components {
    NSExpression *color = [NSExpression expressionForConstantValue:[NSColor class]];
    return [NSExpression expressionForFunction:color selectorName:@"colorWithCalibratedRed:green:blue:" arguments:components];
}

+ (NSExpression *)mgl_expressionForRGBAComponents:(NSArray<NSExpression *> *)components {
    NSExpression *color = [NSExpression expressionForConstantValue:[NSColor class]];
    return [NSExpression expressionForFunction:color selectorName:@"colorWithCalibratedRed:green:blue:alpha:" arguments:components];
}

@end
