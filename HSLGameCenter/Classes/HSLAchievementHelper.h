//
//  HSLAchievementHelper.h
//  HSLGameCenter
//
//  Created by John Arnold on 11-01-16.
//  Copyright (c) 2013 Handelabra Studio LLC. All rights reserved.
//

@class HSLPlayer;
@class HSLAchievement;

@interface HSLAchievementHelper : NSObject

@property (nonatomic, strong) HSLPlayer *player;

- (void)            initializeAchievements;
- (void) initializeAchievementWithName:(NSString*)name category:(NSString*)category submitPartial:(BOOL)submitPartial;
- (HSLAchievement*) achievementWithIdentifier:(NSString*)identifier;
- (void)            updateCachedAchievements:(NSArray*)scores;
- (NSString*)       identifierForAchievementName:(NSString*)name;
- (void)            resetAchievements;
- (NSSet*)          getAchievementsForResubmission;
- (NSSet*) getUnearnedAchievementsInCategory:(NSString*)category;
- (NSSet*) getUnearnedAchievementsWithNames:(NSArray*)names;

- (void) processAchievement:(HSLAchievement*)achievement submitSet:(NSMutableSet*)submitSet newProgress:(double)newProgress;
- (NSSet*)checkAchievementsForCategory:(NSString *)category withObject:(id)arg;
- (NSSet*) awardAchievementNamed:(NSString*)name;

@end
