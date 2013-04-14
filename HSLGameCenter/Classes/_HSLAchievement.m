// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HSLAchievement.m instead.

#import "_HSLAchievement.h"

@implementation HSLAchievementID
@end

@implementation _HSLAchievement

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HSLAchievement" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HSLAchievement";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HSLAchievement" inManagedObjectContext:moc_];
}

- (HSLAchievementID*)objectID {
	return (HSLAchievementID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"submitPartialValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"submitPartial"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic cachedAchievement;






@dynamic category;






@dynamic identifier;






@dynamic progress;



- (double)progressValue {
	NSNumber *result = [self progress];
	return [result doubleValue];
}

- (void)setProgressValue:(double)value_ {
	[self setProgress:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveProgressValue {
	NSNumber *result = [self primitiveProgress];
	return [result doubleValue];
}

- (void)setPrimitiveProgressValue:(double)value_ {
	[self setPrimitiveProgress:[NSNumber numberWithDouble:value_]];
}





@dynamic progressDictionary;






@dynamic status;



- (short)statusValue {
	NSNumber *result = [self status];
	return [result shortValue];
}

- (void)setStatusValue:(short)value_ {
	[self setStatus:[NSNumber numberWithShort:value_]];
}

- (short)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result shortValue];
}

- (void)setPrimitiveStatusValue:(short)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithShort:value_]];
}





@dynamic submitPartial;



- (BOOL)submitPartialValue {
	NSNumber *result = [self submitPartial];
	return [result boolValue];
}

- (void)setSubmitPartialValue:(BOOL)value_ {
	[self setSubmitPartial:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSubmitPartialValue {
	NSNumber *result = [self primitiveSubmitPartial];
	return [result boolValue];
}

- (void)setPrimitiveSubmitPartialValue:(BOOL)value_ {
	[self setPrimitiveSubmitPartial:[NSNumber numberWithBool:value_]];
}





@dynamic player;

	





@end
