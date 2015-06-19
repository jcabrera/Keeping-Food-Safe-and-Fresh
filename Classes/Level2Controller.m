//
//  Level2Controller.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/30/09.
//  Edited by Jennifer Cabrera in 6/2015
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level2Controller.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "DetailViewController.h"

@interface Level2Controller ()

@property (nonatomic, strong) NSMutableArray *listOfItems;




@end

@implementation Level2Controller

- (NSString *) alphaOnly:(NSString *) inputString {
	NSString *newStr = [inputString stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *newStr1 = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"/" withString:@""];
	NSString *newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
	NSString *newStr4 = [newStr3 stringByReplacingOccurrencesOfString:@")" withString:@""];
	
	return newStr4;	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.listOfItems = [[NSMutableArray alloc] init];
	
	//Set the title
	self.navigationItem.title = self.selectedCategory;
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];
	
		NSMutableString *query;
		query = [NSMutableString stringWithFormat:@"select product from detail where category = '%@",self.selectedCategory];
		[query appendString:@"' order by product"];
		
		sqlite3_stmt *statement = nil;
		
		if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
		else
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
				[self.listOfItems addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)]];

		}
		
		
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
    
    // Set up the cell...	
	
	NSString *cellValue = [self.listOfItems objectAtIndex:(NSUInteger)indexPath.row];
    [cell.textLabel setText:cellValue];
    
    //Show images for fruits and vegetables. File names must exactly match item names and be of type .png
    
    if (([self.selectedCategory isEqualToString:@"Fruits"] || [self.selectedCategory isEqualToString:@"Vegetables"])) {
	NSString *imageFile;
	NSString *strippedName;
	strippedName = [self alphaOnly:cellValue];
	imageFile = [[NSBundle mainBundle] pathForResource:strippedName ofType:@"png"];
	strippedName = [strippedName stringByAppendingString:@".png"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:imageFile]) {
		UIImage *image = [UIImage imageNamed:strippedName];
        [cell.imageView setImage:image];
       
	}
	else
	{
		NSLog(@"Image not found:%@",strippedName);		
    }}
	
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	
	NSString *selectedProduce = [self.listOfItems objectAtIndex:(NSUInteger)indexPath.row];
	
	DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:[NSBundle mainBundle]];
    
    [dvController prepareDetailViewControllerProduce:selectedProduce category:self.selectedCategory];
    
	[self.navigationController pushViewController:dvController animated:YES];
	dvController = nil;
}




- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
			return nil;
}
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//if(searching)
	//	return -1;
	
	//NSLog(@"index");
	//NSLog(title);
	//NSLog(@"int %i",index);
	return index % 2;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 17;
}

*/

@end
