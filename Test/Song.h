//
//  Song.h
//  Test
//
//  Created by Admin on 27.07.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * idSong;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * innerID;

+ (NSInteger)allSongCountWithContext:(NSManagedObjectContext *)managedObjectContext;
+ (Song *)songWithManagedObjectContext:(NSManagedObjectContext *)context andInnerID:(NSInteger)songInnerID;

@end
