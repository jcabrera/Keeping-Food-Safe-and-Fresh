//
//  DetailViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/28/09.
//  Edited by Jennifer Cabrera in 6/2015
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Keeping_Food_Safe_and_FreshAppDelegate.h"

@interface DetailViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *selectedProduce;
@property (nonatomic, strong) NSString *selectedCategory;

@end

@implementation DetailViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	NSString *label;
	NSString *detail;
	
	
	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];
	
	NSMutableString *query;
	query = [NSMutableString stringWithFormat:@"select template,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22 from detail where product = '%@",self.selectedProduce];
	[query appendString:@"' and category = '"];
	[query appendString:self.selectedCategory];
	[query appendString:@"'"];

	sqlite3_stmt *statement = nil;
	
	NSString *template = nil;
	NSMutableArray *details = [[NSMutableArray alloc]init];
	NSMutableArray *labels = [[NSMutableArray alloc]init];
		
	
	if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
	else
	{
		while(sqlite3_step(statement)==SQLITE_ROW) {
			template = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)];
			for (int i = 1; i <= 22; ++i) {
				detail = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)];
				[details addObject:detail ];
				
			}
		}
		
	}
	
	
	sqlite3_finalize(statement);
	
	// get labels from template table
	
	query = [NSMutableString stringWithFormat:@"select labels,label1,label2,label3,label4,label5,label6,label7,label8,label9,label10,label11,label12,label13,label14,label15,label16,label17,label18,label19,label20,label21,label22 from template where name = '%@",template]; 
	[query appendString:@"'"];
	statement = nil;
	
	int nlabels = 0;
	
	
	if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
	else
	{
		while(sqlite3_step(statement)==SQLITE_ROW) {
			nlabels = sqlite3_column_int(statement, 0);
			for (int i = 1; i <= nlabels; ++i) {
				label = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)];
				[labels addObject:label];
			}
		}
		
	}
	
	sqlite3_finalize(statement);
	
	
	// end get labels	
	
	
	NSMutableString *HTMLString = [[NSMutableString alloc] init];
	
	[HTMLString appendString:@"<html><head><title>"];
	[HTMLString appendString:self.selectedProduce];
	[HTMLString appendString:@"</title></head>"];
	
	[HTMLString appendString:@"<meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">"];
	[HTMLString appendString:@"<meta http-equiv=""Content-Style-Type"" content=""text/css"">"];
	[HTMLString appendString:@"<meta name=""Generator"" content=""Cocoa HTML Writer"">"];
	[HTMLString appendString:@"<meta name=""CocoaVersion"" content=""949.46"">"];
	[HTMLString appendString:@"<style type=""text/css"">"];

	[HTMLString appendString:@"body, ol, ul, li { margin: 24px; margin-top:0; margin-bottom:0;	padding: 0;  line-height: 60.0px; font: 60.0px Arial;} "];
	[HTMLString appendString:@"</style><body>"];
	
	
	if (!([template isEqualToString: @"Fresh Foods Fruits"] || [template isEqualToString: @"Fresh Foods Vegetables"]))
		[HTMLString appendString:@"<B>Storage Life</B><BR><BR>"];
	
	
		for (int i = 0; i < nlabels; ++i) {
			
			label=[labels objectAtIndex:(NSUInteger)i];
			detail=[details objectAtIndex:(NSUInteger)i];
			
			
			if ([detail length] > 0 && !([detail isEqualToString:@"\"\""])) {
				if (i==8) 
				{
					[HTMLString appendString:@"<B>"];
					[HTMLString appendString:@"Nutritional Information:"];
					[HTMLString appendString:@"</B>"];
					
				}
				if (i>=8) {
					
					[HTMLString appendString:@"<UL>"];
					[HTMLString appendString:@"<LI>"];
					[HTMLString appendString:label];
					[HTMLString appendString:@": "];
					[HTMLString appendString:detail];
					[HTMLString appendString:@"</UL>"];
				}
				else {	
					[HTMLString appendString:@"<B>"];
					[HTMLString appendString:label];
					[HTMLString appendString:@"</B>"];
					
					[HTMLString appendString:@"<UL>"];
					[HTMLString appendString:@"<LI>"];
					[HTMLString appendString:detail];
					[HTMLString appendString:@"</UL>"];
					[HTMLString appendString:@"</BR>"];
				}
			}
		}
		
	
	
	
	if (([template isEqualToString: @"Fresh Foods Fruits"] || [template isEqualToString: @"Fresh Foods Vegetables"])) {
		
		[HTMLString appendString:@"<BR><P>*Storage Life may vary as some fruits and vegetables may be more or less ripe when you purchase them.</P>"];				
	}
	
	[HTMLString appendString:@"</FONT>"];
	
	
	[HTMLString appendString:@"</body></html>"];
	
	[self.webView loadHTMLString:HTMLString baseURL:[NSURL URLWithString:@""]];


	sqlite3_close(db);
	
	//Set the title of the navigation bar
	self.navigationItem.title = self.selectedProduce;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)prepareDetailViewControllerProduce:(NSString *)produce category:(NSString *)category
{
    self.selectedProduce = produce;
    self.selectedCategory = category;
}

@end
