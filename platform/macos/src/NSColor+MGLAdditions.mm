#import "NSColor+MGLAdditions.h"

@implementation NSColor (MGLAdditions)

- (mbgl::Color)mgl_color {
    CGFloat r, g, b, a;

    // The Mapbox Style Specification does not specify a color space, but it is
    // assumed to be sRGB for consistency with CSS.
    [[self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]] getRed:&r green:&g blue:&b alpha:&a];

    return { (float)r, (float)g, (float)b, (float)a };
}

+ (NSColor *)mgl_colorWithColor:(mbgl::Color)color {
    NSColor *srgbColor = [NSColor colorWithRed:color.r green:color.g blue:color.b alpha:color.a];
    // macOS 10.12 Sierra and below uses calibrated RGB by default.
    if ([NSColor redColor].colorSpaceName == NSCalibratedRGBColorSpace) {
        srgbColor = [srgbColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    }
    return srgbColor;
}

- (mbgl::style::PropertyValue<mbgl::Color>)mgl_colorPropertyValue {
    mbgl::Color color = self.mgl_color;
    return {{ color.r, color.g, color.b, color.a }};
}

@end
