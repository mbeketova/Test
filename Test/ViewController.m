//
//  ViewController.m
//  Test
//
//  Created by Admin on 26.07.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//


#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "Song.h"
#import "SongRKObjectManager.h"



@interface ViewController (){
    NSInteger numberOfSong;
    BOOL noRequestsMade;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshView];
    [self linkingSongWhithObjectStore];
}


#pragma mark - RefreshControl

- (void) refreshView {
    //RefreshControl:
    UIView * refreshView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView addSubview:refreshView];
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(refreshingPlayList:) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString * refreshString = [[NSMutableAttributedString alloc]initWithString:@"Ожидание..."];
    [refreshString addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
}

- (void) refreshingPlayList: (UIRefreshControl*)refresh {
    [self linkingSongWhithObjectStore];
    [refresh endRefreshing];
}

#pragma mark - ReloadTableView

- (void) reload_TableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];});
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numberOfSong;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger row = indexPath.row;

    if (numberOfSong > row) {
        Song *curSong = [Song songWithManagedObjectContext:[[SongRKObjectManager manager] managedObjectContext] andInnerID:row];
        
        cell.label_Autor.text = curSong.author;
        cell.label_Song.text = curSong.label;
        }

    return cell;
}

#pragma mark - RestKit

- (void)linkingSongWhithObjectStore {
    //Привязка Core Data к RKManagedObjectStore
    //идентифицируем по атрибуту: idSong
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test" withExtension:@"momd"];
    [[SongRKObjectManager manager] configureWithManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]];
    // Затем добавим маппинг для нашего объекта:
    [[SongRKObjectManager manager] addMappingForEntityForName:@"Song"
                           andAttributeMappingsFromDictionary:@{
                                                                ID:     ID_SONG,
                                                                AUTHOR:  AUTHOR,
                                                                LABEL:   LABEL
                                                                }
                                  andIdentificationAttributes:@[ID_SONG]];
    [self loadSong];
}


- (void)loadSong {
    //В данном методе сначала получаем кол-во песен,
    //а затем производим запрос на получение массива песен с сервера, используя SongRKObjectManager

    numberOfSong = [Song allSongCountWithContext:[[SongRKObjectManager manager] managedObjectContext]];
    
    if (numberOfSong == 0)
        NSLog(@"Здесь рыбы нет!");
    else if (noRequestsMade && numberOfSong > 0) {
        noRequestsMade = NO;
        return;
    }
    
    noRequestsMade = NO;
    
    [[SongRKObjectManager manager] getKilograppObjectsAtPath:nil
                                                  parameters:@{SING_ID : @(numberOfSong)}
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          
                                                          NSInteger newInnerID = 0;
                                                          for (Song *curSong in mappingResult.array) {
                                                              if ([curSong isKindOfClass:[Song class]]) {
                                                                  curSong.innerID = @(newInnerID);
                                                                  newInnerID++;
                                                                  
                                                              }
                                                          }
                                                          
                                                          numberOfSong = newInnerID;

                                                        [self reload_TableView];

                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          [[[UIAlertView alloc] initWithTitle:@"Song API Error" message:operation.error.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil] show];
                                                      }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
