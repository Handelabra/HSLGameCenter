#import "HSLAchievement.h"

@implementation HSLAchievement

// Custom logic goes here.

- (BOOL) isNamed:(NSString*)name;
{
    // prepend the bundle identifier
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *result = [NSString stringWithFormat:@"%@.%@", bundleIdentifier, name];
    
    return [self.identifier isEqualToString:result];
}

@end
