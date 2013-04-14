// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HSLAchievement.h instead.

#import <CoreData/CoreData.h>


@class HSLPlayer;

@class GKAchievement;



@class NSMutableDictionary;



@interface HSLAchievementID : NSManagedObjectID {}
@end

@interface _HSLAchievement : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HSLAchievementID*)objectID;




@property (nonatomic, strong) GKAchievement *cachedAchievement;


//- (BOOL)validateCachedAchievement:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *category;


//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *identifier;


//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *progress;


@property double progressValue;
- (double)progressValue;
- (void)setProgressValue:(double)value_;

//- (BOOL)validateProgress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSMutableDictionary *progressDictionary;


//- (BOOL)validateProgressDictionary:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *status;


@property short statusValue;
- (short)statusValue;
- (void)setStatusValue:(short)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *submitPartial;


@property BOOL submitPartialValue;
- (BOOL)submitPartialValue;
- (void)setSubmitPartialValue:(BOOL)value_;

//- (BOOL)validateSubmitPartial:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) HSLPlayer* player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;




@end

@interface _HSLAchievement (CoreDataGeneratedAccessors)

@end

@interface _HSLAchievement (CoreDataGeneratedPrimitiveAccessors)


- (GKAchievement*)primitiveCachedAchievement;
- (void)setPrimitiveCachedAchievement:(GKAchievement*)value;




- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (double)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(double)value_;




- (NSMutableDictionary*)primitiveProgressDictionary;
- (void)setPrimitiveProgressDictionary:(NSMutableDictionary*)value;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (short)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(short)value_;




- (NSNumber*)primitiveSubmitPartial;
- (void)setPrimitiveSubmitPartial:(NSNumber*)value;

- (BOOL)primitiveSubmitPartialValue;
- (void)setPrimitiveSubmitPartialValue:(BOOL)value_;





- (HSLPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(HSLPlayer*)value;


@end
