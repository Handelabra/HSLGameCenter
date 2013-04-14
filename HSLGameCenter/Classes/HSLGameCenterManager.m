//
//  HSLGameCenterManager.m
//  HSLGameCenter
//
//  Created by John Arnold on 11-01-19.
//  Copyright (c) 2013 Handelabra Studio LLC. All rights reserved.
//
//  Roughly based on GameCenterManager.m from Apple's GKTapper sample.


#import "HSLGameCenterManager.h"
#import <GameKit/GameKit.h>
#import "HSLAchievementHelper.h"
#import "HSLAchievement.h"
#import "HSLPlayer.h"

@interface HSLGameCenterManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation HSLGameCenterManager

- (id) initWithAchievementHelper:(HSLAchievementHelper*)helper managedObjectContext:(NSManagedObjectContext*)managedObjectContext delegate:(id<HSLGameCenterManagerDelegate>)delegate
{
    self = [super init];
    if (self != NULL)
    {
        self.achievementHelper = helper;
        self.managedObjectContext = managedObjectContext;
        self.delegate = delegate;
    }
    return self;
}

- (HSLPlayer*) playerWithID:(NSString*)playerID
{
    // Get or create the player with the ID
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [HSLPlayer entityInManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"playerID == %@", playerID];
    NSError *error = nil;
    NSArray *players = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error != nil)
    {
        NSLog(@"Problem fetching player with ID %@", playerID);
    }

    HSLPlayer *player = nil;

    if (players == nil || [players count] == 0)
    {
        player = [HSLPlayer insertInManagedObjectContext:self.managedObjectContext];
        player.playerID = playerID;
        player.failedScores = [NSMutableSet set];
    }
    else
    {
        player = players[0];
    }

    return player;
}

+ (BOOL) isPlayerAuthenticated
{
    return [GKLocalPlayer localPlayer].isAuthenticated;
}

- (void) authenticate
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *authError) {
        
        if (authError)
        {
            NSLog(@"Error authenticating with Game Center: %@", authError);
        }

        if (viewController)
        {
            // Our delegate should present this
            [self.delegate gameCenterManager:self hasAuthenticationDialog:viewController];
        }
        else if (localPlayer.isAuthenticated)
        {
            // Handle a successful authentication and give the player object to the achievement helper.
            if (self.achievementHelper)
            {
                HSLPlayer *player = [self playerWithID:localPlayer.playerID];
                self.achievementHelper.player = player;
                
                // Ensure the player has an initialized achievement cache
                [self.achievementHelper initializeAchievements];
                
                // Update achievement status from Game Center and cache them
                [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray * scores, NSError * achievementError) {
                     if (achievementError == NULL)
                     {
                         dispatch_async (dispatch_get_main_queue (), ^(void) {
                             [self.achievementHelper updateCachedAchievements:scores];
                             
                             // Save
                             [self save];
                         });
                     }
                     else
                     {
                         // Something broke loading the achievement list.
                         NSLog(@"Error loading achievements: %@", achievementError);
                     }
                 }];
            }
        }
        else
        {
            // Logged out
            self.achievementHelper.player = nil;
        }
    };
}

- (NSString*) categoryForLeaderboardName:(NSString*)name
{
    // prepend the bundle identifier
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *result = [NSString stringWithFormat:@"%@.%@", bundleIdentifier, name];
    
    return result;
}

- (void) reportScore:(int64_t)score forLeaderboardName:(NSString*)name
{
    if ([GKLocalPlayer localPlayer].authenticated)
    {
        NSString *category = [self categoryForLeaderboardName:name];
        
        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];

        scoreReporter.value = score;
        [scoreReporter reportScoreWithCompletionHandler: ^(NSError * error) {
             dispatch_async (dispatch_get_main_queue (), ^(void) {
                 if ([GKLocalPlayer localPlayer].playerID != nil)
                 {
                     HSLPlayer *player = [self playerWithID:[GKLocalPlayer localPlayer].playerID];

                     if (error != nil)
                     {
                         if (error.domain == GKErrorDomain && error.code == GKErrorNotAuthenticated)
                         {
                             // Do not log to flurry if the error is about the player not being authenticated.
                         }
                         else
                         {
                             NSLog(@"Could not report score for category %@.", category);
                         }

                         // Cache the score object to try again later
                         [player.failedScores addObject:scoreReporter];
                     }
                     else
                     {
                         // Remove the object from the cache if it's in there
                         [player.failedScores removeObject:scoreReporter];
                     }

                     // Save the changes
                     [self save];
                 }
             });
         }];
    }
    else
    {
        NSLog(@"Not reporting score, player is not authenticated.");
    }
}

- (int64_t) getScoreForLeaderboardName:(NSString*)name
{
    int64_t __block result = 0;
    
    if ([GKLocalPlayer localPlayer].authenticated)
    {
        NSArray *playerIDs = [NSArray arrayWithObject:[GKLocalPlayer localPlayer].playerID];
        GKLeaderboard *query = [[GKLeaderboard alloc] initWithPlayerIDs:playerIDs];

        if (query != nil)
        {
            query.category = [self categoryForLeaderboardName:name];
            [query loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                if (error != nil)
                {
                    // handle the error.
                }
                if (scores != nil)
                {
                    // process the score information.
                    [scores enumerateObjectsUsingBlock:^(GKScore *obj, NSUInteger idx, BOOL *stop) {
                        result = obj.value;
                        *stop = YES;
                        //NSLog(@"score:%lld",obj.value);
                        //NSLog(@"category:%@",obj.category);
                    }];
                }
            }];
        }
    }
    return result;
}

- (void) incrementScore:(int64_t)amount forLeaderboardName:(NSString *)name
{
    int64_t score = [self getScoreForLeaderboardName:name] + amount;
    [self reportScore:score forLeaderboardName:name];
}

- (NSString*) getLocalPlayerID
{
    NSString *result = nil;
    
    if ([GKLocalPlayer localPlayer].authenticated)
    {
        result = [GKLocalPlayer localPlayer].playerID;
    }
    
    return result;
}

- (void)loadFriendsWithCompletionHandler:(void(^)(NSArray *friends, NSError *error))completionHandler
{
    // We need to get the player's game center friends. All we need are the identifiers.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer loadFriendsWithCompletionHandler:completionHandler];
}

- (void) debugResetAchievements
{
    [self.achievementHelper resetAchievements];

    [GKAchievement resetAchievementsWithCompletionHandler: ^(NSError * error)
     {
     }];

    [self save];
}

- (void) debugEarnAllAchievements
{
    HSLPlayer *player = self.achievementHelper.player;

    for (HSLAchievement *achievement in player.achievements)
    {
        achievement.progress = [NSNumber numberWithDouble:100.0];
        achievement.cachedAchievement = [[GKAchievement alloc] initWithIdentifier:achievement.identifier];
        achievement.cachedAchievement.percentComplete = 100.0;
    }

    [self submitAchievements:player.achievements];
}

- (void) submitAchievements:(NSSet*)achievements
{
    // Add any achievements that need to be re-submitted
    NSSet *resubmitSet = [self.achievementHelper getAchievementsForResubmission];
    NSMutableSet *finalSet = [NSMutableSet setWithSet:achievements];

    [finalSet unionSet:resubmitSet];

    // Save changes before submitting
    [self save];

    for (HSLAchievement *achievement in finalSet)
    {
        if ([GKLocalPlayer localPlayer].authenticated)
        {
            achievement.status = [NSNumber numberWithInt:HSLAchievementStatusSubmissionInProgress];
            achievement.cachedAchievement.showsCompletionBanner = YES;

            [achievement.cachedAchievement reportAchievementWithCompletionHandler: ^(NSError * error)
             {
                 dispatch_async (dispatch_get_main_queue (), ^(void)
                                 {
                                     if (error == nil)
                                     {
                                         // Success
                                         achievement.status = [NSNumber numberWithInt:HSLAchievementStatusSubmitted];
                                     }
                                     else
                                     {
                                         // Failure, we'll try again later automatically.
                                         NSLog( @"Could not submit achievement %@.", achievement.identifier);

                                         achievement.status = [NSNumber numberWithInt:HSLAchievementStatusSubmissionFailed];
                                     }

                                     // Save the changes
                                     [self save];
                                 });
             }];
        }
    }
}


- (void)checkAchievementsForCategory:(NSString *)category withObject:(id)arg
{
    if (self.achievementHelper.player != nil)
    {
        // Get the set of any changed achievements
        NSSet *submitSet = [self.achievementHelper checkAchievementsForCategory:category withObject:arg];
        
        // Submit them
        [self submitAchievements:submitSet];
    }
}

- (void) awardAchievementNamed:(NSString*)name
{
    if (self.achievementHelper.player != nil)
    {
        // Get the set of any changed achievements
        NSSet *submitSet = [self.achievementHelper awardAchievementNamed:name];

        // Submit them
        [self submitAchievements:submitSet];
    }
}

- (void) reloadAchievements
{
    if (self.achievementHelper.player != nil)
    {
        [self.achievementHelper initializeAchievements];
    }
}

#pragma mark - Core Data Stack

- (void)save
{
    NSError *error = nil;
    BOOL saved = NO;
    
    @try
    {
        [self.managedObjectContext processPendingChanges];
        
        if ([self.managedObjectContext hasChanges])
        {
            saved = [self.managedObjectContext save:&error];
            if (!saved)
            {
                NSLog(@"ERROR: HSLGameCenterManager couldn't save managed object context: %@", [error description]);
                
                NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
                if (detailedErrors != nil && [detailedErrors count] > 0)
                {
                    for (NSError* detailedError in detailedErrors)
                    {
                        NSLog(@"  HSLGameCenterManager detailedError: %@", [detailedError userInfo]);
                    }
                }
                else
                {
                    NSLog(@"  HSLGameCenterManager userInfo: %@", [error userInfo]);
                }
            }
        }
    }
    @catch (NSException *ex)
    {
        NSLog(@"ERROR: HSLGameCenterManager save caught exception: %@", ex);
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    
    // If a MOC was provided, use it.
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    // Otherwise, set up a core data stack
    NSURL *momURL = [[NSBundle mainBundle] URLForResource:@"HSLGameCenter" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [documentsDirectory stringByAppendingPathComponent:@"HSLGameCenterManager.sqlite"];
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES)};
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];    
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeUrl
                                                       options:options
                                                         error:&error];
    if (store) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = psc;
    } else {
        NSLog(@"ERROR: %@", error);
    }
    
    return _managedObjectContext;
}


@end
