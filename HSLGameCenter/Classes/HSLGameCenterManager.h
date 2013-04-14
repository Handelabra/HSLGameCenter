//
//  HSLGameCenterManager.h
//  HSLGameCenter
//
//  Created by John Arnold on 11-01-19.
//  Copyright (c) 2013 Handelabra Studio LLC. All rights reserved.
//
//  HSLGameCenterManager is a helper library for Game Center. It provides caching of achievement and leaderboard progress
//  and a standardized method for checking and awarding achievements.
//
//  Requires iOS 6.0+ and ARC. Uses Core Data for data storage.
// 
//  Roughly based on GameCenterManager.h from Apple's GKTapper sample.

@class GKLeaderboard;
@class GKAchievement;
@class GKPlayer;
@class HSLAchievementHelper;
@class HSLGameCenterManager;

@protocol HSLGameCenterManagerDelegate <NSObject>
- (void)gameCenterManager:(HSLGameCenterManager*)manager hasAuthenticationDialog:(UIViewController*)dialog;
@end

@interface HSLGameCenterManager : NSObject

@property (nonatomic, strong) HSLAchievementHelper *achievementHelper;
@property (nonatomic, weak) id<HSLGameCenterManagerDelegate> delegate;

- (id) initWithAchievementHelper:(HSLAchievementHelper*)helper managedObjectContext:(NSManagedObjectContext*)managedObjectContext delegate:(id<HSLGameCenterManagerDelegate>)delegate;

+ (BOOL) isPlayerAuthenticated;
- (void) authenticate;

- (void) reportScore:(int64_t)score forLeaderboardName:(NSString*)name;
- (int64_t) getScoreForLeaderboardName:(NSString*)name;
- (void) incrementScore:(int64_t)amount forLeaderboardName:(NSString *)name;

- (void) debugResetAchievements;
- (void) debugEarnAllAchievements;

- (NSString*) getLocalPlayerID;
- (void)loadFriendsWithCompletionHandler:(void(^)(NSArray *friends, NSError *error))completionHandler;

- (void) checkAchievementsForCategory:(NSString*)category withObject:(id)arg;
- (void) awardAchievementNamed:(NSString*)name;
- (void) reloadAchievements;

@end
