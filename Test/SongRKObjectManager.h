//
//  SongRKObjectManager.h
//  Test
//
//  Created by Admin on 28.07.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"


@interface SongRKObjectManager : NSObject

- (id) init;

+ (SongRKObjectManager *)manager;

- (NSManagedObjectContext *)managedObjectContext;

- (void)configureWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel;

- (void) addMappingForEntityForName:(NSString *)nameClass
        andAttributeMappingsFromDictionary:(NSDictionary *)attributeMappings
        andIdentificationAttributes:(NSArray *)ids;

- (void)getKilograppObjectsAtPath:(NSString *)path
                       parameters:(NSDictionary *)params
                          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;



@end
