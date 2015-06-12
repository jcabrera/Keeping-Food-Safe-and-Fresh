//
//  Keeping_Food_Safe_and_FreshAppDelegate.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Keeping_Food_Safe_and_FreshAppDelegate.h"
#import "RootViewController.h"
#import "CategoryViewController.h"


@implementation Keeping_Food_Safe_and_FreshAppDelegate

/*@synthesize window;
@synthesize navigationController;*/


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
    /*[self.window setRootViewController:navigationController];
	[window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];*/
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}



+(sqlite3 *) getNewDBConnection{
	sqlite3 *newDBconnection;
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"FoodSafety.sqlite"];
	
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	
	[fileManager removeItemAtPath:dbPath error:&error];
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FoodSafety.sqlite"];
	BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
	
	if (!success)
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	
	
	NSLog(@"Database path: %@",dbPath);
	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([dbPath UTF8String], &newDBconnection) == SQLITE_OK) {
		
		NSLog(@"Database Successfully Opened :)");
		
	} else {
		NSLog(@"Error in opening database :(");
	}
	
	return newDBconnection; 
}

@end
