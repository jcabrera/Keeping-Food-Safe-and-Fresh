//
//  RootViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "Level2Controller.h"


@implementation RootViewController

@synthesize keys;
@synthesize dictionary;
	
		
- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	 
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	self.dictionary = dict;
	[dict release];
	
	NSArray *array = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
	self.keys = array;
	*/
	
	//Set the title
//	self.navigationItem.title = @"Keeping Food Safe and Fresh";
	self.navigationItem.title = @"Food Storage and Shelf Life";

	
	self.keys = [[NSMutableArray alloc]init];
	self.dictionary = [[NSMutableDictionary alloc]init];

	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];

	for(char c='A';c<='Z';c++)
	{
		NSMutableString *query;
		query = [NSMutableString stringWithFormat:@"select distinct category from detail where category LIKE '%c",c]; 
		[query appendString:@"%' order by category"];
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
				[self.keys addObject:[NSString stringWithFormat:@"%c",c]];
				[self.dictionary setObject:arrayOfNames forKey:[NSString stringWithFormat:@"%c",c]];
			}
		}
		
				/*
				 int row = sqlite3_column_int(statement, 0);
				 NSString *title = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				 */
				
		sqlite3_finalize(statement);
        
	}
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
	return (NSInteger)[dictionary count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return 0;	

	NSString *key = [keys objectAtIndex:(NSUInteger)section];
	NSArray *nameSection = [dictionary objectForKey:key];
	
	return (NSInteger)[nameSection count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...	
	
// custom 2 lines here
	
	// Set up the cell
//	cell.text = [[dictionary objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	[[cell textLabel] setText:[[dictionary objectForKey:[keys objectAtIndex:(NSUInteger)indexPath.section]] objectAtIndex:(NSUInteger)indexPath.row]];

/*	
	UILabel* label = [[UILabel alloc] initWithFrame:cell.frame];
	label.numberOfLines = 0;
	label.text =  [[dictionary objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];;
	label.font = [UIFont fontWithName:@"Arial" size:17.0];
	[label sizeToFit];
	[cell addSubview:label];
	[label release];
*/
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	NSString *selectedCategory = [[dictionary objectForKey:[keys objectAtIndex:(NSUInteger)indexPath.section]] objectAtIndex:(NSUInteger)indexPath.row];

	Level2Controller *level2Controller = [[Level2Controller alloc] initWithNibName:@"Level2Controller" bundle:[NSBundle mainBundle]];
    
    [level2Controller prepareLevel2ControllerWith:selectedCategory];
    
	[self.navigationController pushViewController:level2Controller animated:YES];
	level2Controller = nil;
}


	
	

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
//	if(searching)
//		return nil;


	// A to Z
	/* NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for(char c = 'A';c<='Z';c++) 
		[tempArray addObject:[NSString stringWithFormat:@"%c",c]];
	return tempArray;
	*/

	// just the letters that have data
	//return keys;
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	//NSLog(@"sectionForSectionIndexTitle title: %@",title);
	
	//if(searching)
	//	return -1;

	NSInteger count = 0;
	for(NSString *character in keys)
	{
		if([character isEqualToString:title])
			return count;
		count ++;
	}
	return 0;// in case of some eror donot crash d application

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *key = [keys objectAtIndex:(NSUInteger)section];
	return key;
	
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {return 30;} else {
        return 25;}
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == ((NSInteger)dictionary.count-1)) {
        return 17;} else {
            return 5;
        };
}

@end

	
