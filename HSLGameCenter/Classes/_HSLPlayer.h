// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HSLPlayer.h instead.

#import <CoreData/CoreData.h>


@class HSLAchievement;

@class NSMutableSet;


@interface HSLPlayerID : NSManagedObjectID {}
@end

@interface _HSLPlayer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HSLPlayerID*)objectID;




@property (nonatomic, strong) NSMutableSet *failedScores;


//- (BOOL)validateFailedScores:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *playerID;


//- (BOOL)validatePlayerID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* achievements;

- (NSMutableSet*)achievementsSet;




@end

@interface _HSLPlayer (CoreDataGeneratedAccessors)

- (void)addAchievements:(NSSet*)value_;
- (void)removeAchievements:(NSSet*)value_;
- (void)addAchievementsObject:(HSLAchievement*)value_;
- (void)removeAchievementsObject:(HSLAchievement*)value_;

@end

@interface _HSLPlayer (CoreDataGeneratedPrimitiveAccessors)


- (NSMutableSet*)primitiveFailedScores;
- (void)setPrimitiveFailedScores:(NSMutableSet*)value;




- (NSString*)primitivePlayerID;
- (void)setPrimitivePlayerID:(NSString*)value;





- (NSMutableSet*)primitiveAchievements;
- (void)setPrimitiveAchievements:(NSMutableSet*)value;


@end
