#import "NSColor+MGLAdditions.h"

@implementation NSColor (MGLAdditions)

- (mbgl::Color)mgl_color
{
    CGFloat r, g, b, a;

    // The Mapbox Style Specification does not specify a color space, but it is
    // assumed to be sRGB for consistency with CSS.
    // As of OS X 10.8 Mountin Lion, device RGB is equivalent to sRGB.
    // https://download.developer.apple.com/wwdc_2012/wwdc_2012_session_pdfs/session_523__best_practices_for_color_management.pdf#page=137
    [[self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed:&r green:&g blue:&b alpha:&a];

    return { (float)r, (float)g, (float)b, (float)a };
}

+ (NSColor *)mgl_colorWithColor:(mbgl::Color)color
{
    return [NSColor colorWithRed:color.r green:color.g blue:color.b alpha:color.a];
}

- (mbgl::style::PropertyValue<mbgl::Color>)mgl_colorPropertyValue
{
    mbgl::Color color = self.mgl_color;
    return {{ color.r, color.g, color.b, color.a }};
}

@end
