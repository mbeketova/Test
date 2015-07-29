//
//  Song.m
//  Test
//
//  Created by Admin on 27.07.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "Song.h"


@implementation Song

@dynamic author;
@dynamic idSong;
@dynamic label;
@dynamic innerID;

+ (NSInteger)allSongCountWithContext:(NSManagedObjectContext *)managedObjectContext{
    NSUInteger retVal;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error;
    retVal = [managedObjectContext countForFetchRequest:request error:&error];
     
     if (error)
         NSLog(@"Error: %@", [error localizedDescription]);
    
    return retVal;
}

 + (Song *)songWithManagedObjectContext:(NSManagedObjectContext *)context andInnerID:(NSInteger)songInnerID{
    Song *retVal = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"innerID = %d", songInnerID];
    [request setPredicate:searchFilter];
    
    NSError * error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
        retVal = [results objectAtIndex:0];
     if (error)
         NSLog(@"Error: %@", [error localizedDescription]);
    
    return retVal;
}

@end
