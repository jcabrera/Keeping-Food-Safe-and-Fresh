//
//  RootViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/27/09.
//  Edited by Jennifer Cabrera in 6/2015
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "Level2Controller.h"

@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray *listOfItems;
@property (nonatomic, strong) NSString *rootSelectedCategory;

@end


@implementation RootViewController


	
		
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Set the title

    self.navigationItem.title = self.template;

    self.listOfItems = [[NSMutableArray alloc]init];
	
	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];

		NSMutableString *query;
		
        query = [NSMutableString stringWithFormat:@"select distinct category from detail where template LIKE '%@",self.template];
        [query appendString:@"%' order by category"];
		
		sqlite3_stmt *statement = nil;
		
		if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
		else
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
				[self.listOfItems addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)]];
				
		sqlite3_finalize(statement);
        
	}
	
}




/* Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return (NSInteger)[self.listOfItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	// Set up the cell
    NSString *cellValue = [self.listOfItems objectAtIndex:(NSUInteger)indexPath.row];
    [[cell textLabel] setText:cellValue];
	return cell;	
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.

}
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        
    if ([segue.identifier isEqualToString:@"Next"]) {
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        self.rootSelectedCategory = [self.listOfItems objectAtIndex:(NSUInteger)indexPath.row];
        
        Level2Controller *level2Controller = [segue destinationViewController];
        level2Controller.selectedCategory = self.rootSelectedCategory;
    
    }

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	return nil;
}



-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;

}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 0;
}

@end

	
