//
//  CategoryViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by Jennifer Cabrera on 6/5/15.
//
//

#import "CategoryViewController.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "Level2Controller.h"


@interface CategoryViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSString *topCategoryName;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
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
    // Note that all template images must be renamed with .jpg extension, and their names must match the categories exactly
    
    
    CategoryImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
   
    
    self.topCategoryName = self.categories[(NSUInteger)indexPath.item];
    cell.cellLabel.text = self.topCategoryName;
    self.topCategoryName = [self.topCategoryName stringByAppendingString:@".jpg"];
    cell.imageView.image = [UIImage imageNamed:self.topCategoryName];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     self.topCategoryName = self.categories[(NSUInteger)indexPath.item];
    
    // Most templates only have one category, so this skips down to the Level2 screen for those categories
    
    if (([self.topCategoryName isEqualToString:@"Foods Purchased Refrigerated"]) || ([self.topCategoryName isEqualToString:@"Shelf Stable Foods"])) {
        [self performSegueWithIdentifier:@"Root" sender:self];
    }
    else {
         [self performSegueWithIdentifier:@"Level2" sender:self];
    }
   
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"Root"]) {
        
    RootViewController *nextViewController = [segue destinationViewController];
        nextViewController.template = self.topCategoryName;}
    else if ([segue.identifier isEqualToString: @"Level2"]){
        NSString *newCategory = nil;
        //Rename category to match 2nd column of database
        if ([self.topCategoryName isEqualToString:@"Foods Purchased Frozen"]) {
            newCategory = @"Freezer";}
        else if ([self.topCategoryName isEqualToString:@"Fresh Foods Fruits"]){
            newCategory = @"Fruits";}
        else if ([self.topCategoryName isEqualToString:@"Fresh Foods Vegetables"]){
            newCategory = @"Vegetables";}
        else newCategory = self.topCategoryName;
        
  
    
        Level2Controller *level2Controller = [segue destinationViewController];
    level2Controller.selectedCategory = newCategory;
        
   
    }

}
@end
