//
//  CategoryViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by Jennifer Cabrera on 6/5/15.
//
//

#import "CategoryViewController.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"

@interface CategoryViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"Food Storage and Shelf Life";
    
    
    self.keys = [[NSMutableArray alloc]init];
    self.dictionary = [[NSMutableDictionary alloc]init];
    self.categories = [[NSMutableArray alloc]init];
    
    sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];
    
    for(char c='A';c<='Z';c++)
    {
        NSMutableString *query;
        query = [NSMutableString stringWithFormat:@"select distinct template from detail where template LIKE '%c",c];
        [query appendString:@"%' order by template"];
        //char *sql = [query cString];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
        else
        {
            NSMutableArray *arrayOfNames = [[NSMutableArray alloc]init];
            while(sqlite3_step(statement)==SQLITE_ROW)
                [arrayOfNames addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)]];
            if([arrayOfNames count] >0)
            {
                for (int i = 0; i < (integer_t)[arrayOfNames count]; i++) {
                    [self.categories addObject:arrayOfNames[(NSUInteger)i]];
                }
                [self.keys addObject:[NSString stringWithFormat:@"%c",c]];
                [self.dictionary setObject:arrayOfNames forKey:[NSString stringWithFormat:@"%c",c]];
            }
        }
        
        
        sqlite3_finalize(statement);
        
        [self.collectionView reloadData];
        
        
    }
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    int i=0;
    NSString *key = [[NSString alloc] init];
    for (key in self.keys) {
        NSMutableArray *itemsForKey = [self.dictionary objectForKey:key];
        int count = (integer_t)[itemsForKey count];
        i = i + count;
        
    }
    return (NSInteger)i;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
   
    
    NSString *categoryName = self.categories[(NSUInteger)indexPath.item];
    cell.cellLabel.text = categoryName;
    categoryName = [categoryName stringByAppendingString:@".jpg"];
    cell.imageView.image = [UIImage imageNamed:categoryName];
    return cell;
}


/*#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *categoryName = self.categories[(NSUInteger)indexPath.item];
   
}
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *index = [self.collectionView indexPathForCell:sender];
    NSString *categoryName = self.categories[(NSUInteger)index.item];
    UINavigationController *navController = [segue destinationViewController];
    RootViewController *nextViewController = (RootViewController *)[navController topViewController];
    nextViewController.template = categoryName;

}
@end
