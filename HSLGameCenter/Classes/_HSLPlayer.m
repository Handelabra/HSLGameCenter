// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HSLPlayer.m instead.

#import "_HSLPlayer.h"

@implementation HSLPlayerID
@end

@implementation _HSLPlayer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HSLPlayer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HSLPlayer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HSLPlayer" inManagedObjectContext:moc_];
}

- (HSLPlayerID*)objectID {
	return (HSLPlayerID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic failedScores;






@dynamic playerID;






@dynamic achievements;

	
- (NSMutableSet*)achievementsSet {
	[self willAccessValueForKey:@"achievements"];
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"achievements"];
	[self didAccessValueForKey:@"achievements"];
	return result;
}
	





@end
