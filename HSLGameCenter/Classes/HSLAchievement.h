#import "_HSLAchievement.h"

typedef enum HSLAchievementStatus
{
    HSLAchievementStatusNew,
    HSLAchievementStatusPendingSubmission,
    HSLAchievementStatusSubmissionInProgress,
    HSLAchievementStatusSubmitted,
    HSLAchievementStatusSubmissionFailed
} HSLAchievementStatus;

@interface HSLAchievement : _HSLAchievement {}
// Custom logic goes here.

- (BOOL) isNamed:(NSString*)name;

@end
