//
//  ViewController.m
//  DemoObjecti
//
//  Created by Puneeth Kumar  on 27/12/16.
//  Copyright © 2016 ASM Technologies Limited. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//#import <CoreData/CoreData.h>
#import "CustomTableViewCell.h"
#import "GeoName+CoreDataProperties.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSManagedObjectContext *manageObjectContext;

    NSArray *collectionList;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    manageObjectContext = appDelegate.persistentContainer.viewContext;
    
    collectionList = [[NSArray alloc] init];
    
    [self fetchRequest];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [collectionList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   static NSString *identiFier = @"myCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiFier forIndexPath:indexPath];
    
    GeoName *obkject = [collectionList objectAtIndex:indexPath.row];
    cell.countryCode.text = obkject.countrycode;
    cell.nameTitle.text = obkject.name;
    return cell;
}


-(void)fetchRequest{
    
    NSString *str =  @"http://api.geonames.org/citiesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&lang=de&username=demo";
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *task =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [self populateManageObjectContext:dict];
        }];
        
    }];
    [task resume];
  
}

-(NSArray*)fetchDataFromCoreData{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GeoName"];
    NSArray *colllectioArray = [manageObjectContext executeFetchRequest:request error:nil];
    return colllectioArray;
}

-(void)populateManageObjectContext:(NSDictionary*)dict{
    
    NSArray *listArra = [dict objectForKey:@"geonames"];
    
    for (NSDictionary *loDict in listArra){
        GeoName *geoName  = [NSEntityDescription insertNewObjectForEntityForName:@"GeoName"     inManagedObjectContext:manageObjectContext];
        geoName.lng = [[loDict objectForKey:@"lng"] floatValue];
        geoName.geonameId = [[loDict objectForKey:@"geonameId"] floatValue];
        geoName.countrycode = [loDict objectForKey:@"countrycode"];
        geoName.name = [loDict objectForKey:@"name"];
        
        geoName.toponymName = @"gdhshgdsa";
        [manageObjectContext  save:nil];
 
    }
    
    collectionList = [self fetchDataFromCoreData];

    [_mTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
