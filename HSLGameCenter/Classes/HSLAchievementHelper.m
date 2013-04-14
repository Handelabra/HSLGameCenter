//
//  HSLAchievementHelper.m
//  HSLGameCenter
//
//  Created by John Arnold on 11-01-16.
//  Copyright (c) 2013 Handelabra Studio LLC. All rights reserved.
//

#import "HSLAchievementHelper.h"
#import "HSLPlayer.h"
#import "HSLAchievement.h"
#import <GameKit/GameKit.h>
#import "HSLGameCenterManager.h"

@implementation HSLAchievementHelper

#pragma mark -
#pragma mark Achievement methods

// ALL achievements MUST be initialized here!
- (void) initializeAchievements
{
    // Subclasses must implement
    [self doesNotRecognizeSelector:_cmd];
}

- (HSLAchievement*) achievementWithIdentifier:(NSString*)identifier
{
    HSLAchievement *achievement = nil;

    if (self.player)
    {
        // Get or create the achievement with the player and identifier
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
        NSSet *filteredSet = [self.player.achievements filteredSetUsingPredicate:predicate];

        if (filteredSet.count == 0)
        {
            // Create the achievement and associate it with the player
            achievement = [HSLAchievement insertInManagedObjectContext:self.player.managedObjectContext];
            achievement.identifier = identifier;
            achievement.player = self.player;
            achievement.status = [NSNumber numberWithInt:HSLAchievementStatusNew];
        }
        else
        {
            achievement = (HSLAchievement*)[filteredSet anyObject];
        }
    }

    return achievement;
}


- (void) initializeAchievementWithName:(NSString*)name category:(NSString*)category submitPartial:(BOOL)submitPartial
{
    // Check if the player already has the achievement with that identifier. If not, create it.
    NSString *identifier = [self identifierForAchievementName:name];
    HSLAchievement *achievement = [self achievementWithIdentifier:identifier];

    achievement.category = category;
    achievement.submitPartial = [NSNumber numberWithBool:submitPartial];
}

- (void) updateCachedAchievements:(NSArray*)scores
{
    for (GKAchievement *score in scores)
    {
        // Pull up the achievement from core data
        HSLAchievement *achievement = [self achievementWithIdentifier:score.identifier];

        // If the new score has a higher percent complete, replace the progress and cached achievement
        if (score.percentComplete > [achievement.progress doubleValue])
        {
            achievement.progress = [NSNumber numberWithDouble:score.percentComplete];
            achievement.status = [NSNumber numberWithInt:HSLAchievementStatusSubmitted];
            achievement.cachedAchievement = score;
        }

        // Otherwise the cached achievement is more up to date, it just hasn't been submitted successfully yet.
    }
}

- (void) resetAchievements
{
    for (HSLAchievement *achievement in self.player.achievements)
    {
        achievement.progress = [NSNumber numberWithDouble:0.0];
        achievement.progressDictionary = nil;
        achievement.cachedAchievement = nil;
        achievement.status = [NSNumber numberWithInt:HSLAchievementStatusNew];
    }
}

- (NSString*) identifierForAchievementName:(NSString*)name
{
    // prepend the bundle identifier
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *result = [NSString stringWithFormat:@"%@.%@", bundleIdentifier, name];

    return result;
}

- (NSSet*) getAchievementsForResubmission
{
    // We want achievements where status != nil && status = failed
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:HSLAchievementStatusSubmissionFailed]];
    NSSet *filteredSet = [self.player.achievements filteredSetUsingPredicate:predicate];

    return filteredSet;
}

- (NSSet*) getUnearnedAchievementsInCategory:(NSString*)category
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@ AND progress < %@", category, [NSNumber numberWithDouble:100.0]];
    NSSet *filteredSet = [self.player.achievements filteredSetUsingPredicate:predicate];

    return filteredSet;
}

- (NSSet*) getUnearnedAchievementsWithNames:(NSArray*)names
{
    // Convert names to identifiers
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity:[names count]];

    for (NSString *name in names)
    {
        [identifiers addObject:[self identifierForAchievementName:name]];
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier IN %@ AND progress < %@", identifiers, [NSNumber numberWithDouble:100.0]];
    NSSet *filteredSet = [self.player.achievements filteredSetUsingPredicate:predicate];
    return filteredSet;
}

- (void) processAchievement:(HSLAchievement*)achievement submitSet:(NSMutableSet*)submitSet newProgress:(double)newProgress
{
    double oldProgress = [achievement.progress doubleValue];

    if (newProgress > 100.0)
    {
        newProgress = 100.0;
    }

    // Record the new progress if it has increased from the old progress.
    if (oldProgress < newProgress)
    {
        achievement.progress = [NSNumber numberWithDouble:newProgress];
        achievement.status = [NSNumber numberWithInt:HSLAchievementStatusPendingSubmission];

        // Set up the cached achievement object if it does not yet exist. Otherwise reuse the one we have.
        if (achievement.cachedAchievement == nil)
        {
            achievement.cachedAchievement = [[GKAchievement alloc] initWithIdentifier:achievement.identifier];
        }

        achievement.cachedAchievement.percentComplete = newProgress;

        // Submit the progress if it's 100% or if we should submit partial values
        if (newProgress >= 100.0 || [achievement.submitPartial boolValue])
        {
            [submitSet addObject:achievement];
        }
    }
}

- (NSSet*)checkAchievementsForCategory:(NSString *)category withObject:(id)arg
{
    // Subclasses should override.
    return [NSSet set];
}

- (NSSet*) awardAchievementNamed:(NSString*)name
{
    NSMutableSet *submitSet = [NSMutableSet set];

    NSSet *filteredSet = [self getUnearnedAchievementsWithNames:[NSArray arrayWithObjects:name, nil]];

    for (HSLAchievement *achievement in filteredSet)
    {
        // We always award the achievement with this method, whatever it is.
        double newProgress = 100.0;

        [self processAchievement:achievement submitSet:submitSet newProgress:newProgress];
    }

    return submitSet;
}

@end
