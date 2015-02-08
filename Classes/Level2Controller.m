//
//  Level2Controller.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level2Controller.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "DetailViewController.h"

@implementation Level2Controller
@synthesize keys;
@synthesize selectedCategory;

- (NSString *) alphaOnly:(NSString *) inputString {
	//NSLog(@"Original: %@",inputString);
	NSString *newStr = [inputString stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *newStr1 = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"/" withString:@""];
	NSString *newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
	NSString *newStr4 = [newStr3 stringByReplacingOccurrencesOfString:@")" withString:@""];
	//NSLog(@"Stripped word: %@",newStr4);
	return newStr4;	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	listOfItems = [[NSMutableArray alloc] init];
	
/*
	NSString *catFile;
	NSString *strippedName;
	strippedName = [self alphaOnly:selectedCategory];
	catFile = [[NSBundle mainBundle] pathForResource:strippedName ofType:@"txt"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:catFile]) {
		catFile = [[NSBundle mainBundle] pathForResource:@"NotYetImplemented" ofType:@"txt"];
	}
	
	
	NSString *fileString = [NSString stringWithContentsOfFile:catFile]; // reads file into memory as an NSString
	NSArray *lines = [fileString componentsSeparatedByString:@"\n"]; // each line, adjust character for line endings	
	
	// NSArray *array = [[lines allKeys] sortedArrayUsingSelector:@selector(compare:)];
	self.keys = lines;
		
	for (NSString *string in lines) {
		[listOfItems addObject:string];
	}
	
	
*/
	//Set the title
	self.navigationItem.title = selectedCategory;
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];
	
		NSMutableString *query;
		query = [NSMutableString stringWithFormat:@"select product from detail where category = '%@",selectedCategory]; 
		[query appendString:@"' order by product"];
		//char *sql = [query cString];
		sqlite3_stmt *statement = nil;
		
		if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
		else
		{
//			NSMutableArray *arrayOfNames = [[NSMutableArray alloc]init];
			while(sqlite3_step(statement)==SQLITE_ROW)
				[listOfItems addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)]];
/*
			[arrayOfNames addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)]];
			if([arrayOfNames count] >0)
			{
				[self.keys addObject:[NSString stringWithFormat:@"%c",c]];
				[self.dictionary setObject:arrayOfNames forKey:[NSString stringWithFormat:@"%c",c]];
			}
			[arrayOfNames release];
 */
		}
		
		/*
		 int row = sqlite3_column_int(statement, 0);
		 NSString *title = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
		 */
		
		sqlite3_finalize(statement);
	
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return 0;
	return [listOfItems count];
	;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...	
	
	// custom 2 lines here
	NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];

//	cell.text = cellValue;
	[[cell textLabel] setText:cellValue];
	
	/*
	UILabel* label = [[UILabel alloc] initWithFrame:cell.frame];
	label.numberOfLines = 1;
	label.text = cellValue;
	label.font = [UIFont fontWithName:@"Arial" size:17.0];
	[cell addSubview:label];
	[label release];
*/	

	NSString *imageFile;
	NSString *strippedName;
	strippedName = [self alphaOnly:cellValue];
	imageFile = [[NSBundle mainBundle] pathForResource:strippedName ofType:@"png"];
	strippedName = [strippedName stringByAppendingString:@".png"];
	
	//NSLog(@"Searching for image:%@",strippedName);
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:imageFile]) {
		UIImage *image = [UIImage imageNamed:strippedName];
		//cell.image = image;
		[cell imageView].image = image;
	}
	else
	{
		NSLog(@"Image not found:%@",strippedName);		
	}
	
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	NSString *selectedProduce = [listOfItems objectAtIndex:indexPath.row];
	
	DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:[NSBundle mainBundle]];
	dvController.selectedProduce = selectedProduce;
	dvController.selectedCategory = selectedCategory;
	[self.navigationController pushViewController:dvController animated:YES];
	dvController = nil;
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
			return nil;

	/*
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for(char c = 'A';c<='Z';c++) 
		[tempArray addObject:[NSString stringWithFormat:@"%c",c]];	
	return tempArray;
	 */
	
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//if(searching)
	//	return -1;
	
	//NSLog(@"index");
	//NSLog(title);
	//NSLog(@"int %i",index);
	return index % 2;
}


@end


