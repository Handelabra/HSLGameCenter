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

/**
 HSLGameCenterManager is the main interface to the HSLGameCenter library. You should keep it around in a long-lived object, at least as long as your user is on Game Center.
 */
@interface HSLGameCenterManager : NSObject

@property (nonatomic, strong) HSLAchievementHelper *achievementHelper;
@property (nonatomic, weak) id<HSLGameCenterManagerDelegate> delegate;

/**
 Returns a configured manager object.
 
 @param helper Optional achievement helper object that will be used to manipulate achievements. Normally this is an instance of your custom subclass. If this parameter is nil, none of the achievement methods will do anything.
 @param managedObjectContext Optional Core Data managed object context that will be used to modify and store achievement & leaderboard cache data. This should be a main thread context whose store & managed object model include the HSLGameCenter data model. If this parameter is nil, the manager will create its own Core Data stack when needed.
 @param delegate The delegate of the manager.
 @return A configured manager object.
 */
- (id) initWithAchievementHelper:(HSLAchievementHelper*)helper managedObjectContext:(NSManagedObjectContext*)managedObjectContext delegate:(id<HSLGameCenterManagerDelegate>)delegate;

/**
 Check if a player is authenticated with Game Center.
 
 @return YES if the player is authenticated, NO if not.
 */
+ (BOOL) isPlayerAuthenticated;

/**
 Initiate authentication with Game Center. The delegate will be notified of authentication changes.
 */
- (void) authenticate;

/**
 Gets the opaque player identifier of the local player.
 
 @return The Game Center player identifier of the authenticated player, or nil if the player is not authenticated.
 */
- (NSString*) getLocalPlayerID;

/** @name Leaderboard support methods */

/**
 
 */
- (void) reportScore:(int64_t)score forLeaderboardName:(NSString*)name;
- (int64_t) getScoreForLeaderboardName:(NSString*)name;
- (void) incrementScore:(int64_t)amount forLeaderboardName:(NSString *)name;




/** @name Achievement support methods */

- (void) checkAchievementsForCategory:(NSString*)category withObject:(id)arg;
- (void) awardAchievementNamed:(NSString*)name;
- (void) reloadAchievements;

/** @name Debug methods */

- (void) debugResetAchievements;
- (void) debugEarnAllAchievements;

@end
