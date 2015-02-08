//
//  DetailViewController.m
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/28/09.
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

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

// DetailViewController.m
- (void)viewDidLoad {
	[super viewDidLoad];
		
	/*
	 NSLog(@"viewDidLoad");
	 NSLog(@"Webview origin x %f", [webView frame].origin.x);
	 NSLog(@"Webview origin y %f", [webView frame].origin.y);
	 NSLog(@"Webview width %f", [webView frame].size.width);
	 NSLog(@"Webview height %f",[webView frame].size.height);
	 NSLog(@"----------");
	 */
	
	//Display the selected country.
	//lblText.text = @"Test";
	
	NSString *htmlFile;
	NSString *label;
	NSString *detail;
	
	
	htmlFile = [[NSBundle mainBundle] pathForResource:self.selectedProduce ofType:@"html"];
	//	[webView loadHTMLString:@"<HTML>Selection:Firm, crisp, well-colored, no bruises or soft spots</HTML>" baseURL:nil];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	//NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"PDF Services"];
	if (![fm fileExistsAtPath:htmlFile]) {
		
		//		NSLog(@"Not found:");
		//		NSLog(selectedProduce);
		/*
		 NSString *newStr = [selectedProduce stringByReplacingOccurrencesOfString:@"," withString:@""];
		 NSString *newStr1 = [newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
		 NSString *newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"/" withString:@""];
		 NSString *newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
		 NSString *newStr4 = [newStr3 stringByReplacingOccurrencesOfString:@")" withString:@""];
		 NSLog(newStr4);
		 htmlFile = [[NSBundle mainBundle] pathForResource:newStr4 ofType:@"html"];
		 
		 if (![fm fileExistsAtPath:htmlFile]) {
		 htmlFile = [[NSBundle mainBundle] pathForResource:@"NotYetImplemented" ofType:@"html"];
		 }
		 */
	}
	
	// I left off here.	
	//	NSLog(@"Loading UIWebView");
	
	
	// NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
	//	[webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]]; 
	
	sqlite3 *db = [Keeping_Food_Safe_and_FreshAppDelegate getNewDBConnection];
	
	NSMutableString *query;
	query = [NSMutableString stringWithFormat:@"select template,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22 from detail where product = '%@",self.selectedProduce];
	[query appendString:@"' and category = '"];
	[query appendString:self.selectedCategory];
	[query appendString:@"'"];
	
	//	NSLog(@"query: ",query);
	//	char *sql = [query UTF8String];
	// char *sql  = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *statement = nil;
	
	NSString *template = nil;
	NSMutableArray *details = [[NSMutableArray alloc]init];
	NSMutableArray *labels = [[NSMutableArray alloc]init];
		
	
	//	NSLog(@"query: %@",query);
	
	if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
	else
	{
		//		NSMutableArray *arrayOfNames = [[NSMutableArray alloc]init];
		while(sqlite3_step(statement)==SQLITE_ROW) {
			template = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)];
			for (int i = 1; i <= 22; ++i) {
//				detail = [[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)] autorelease];
				detail = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)];
				[details addObject:detail ];
				
			}
		}
		
	}
	NSLog(@"finish loop");
	
	sqlite3_finalize(statement);
	
	// get labels from template table
	
	query = [NSMutableString stringWithFormat:@"select labels,label1,label2,label3,label4,label5,label6,label7,label8,label9,label10,label11,label12,label13,label14,label15,label16,label17,label18,label19,label20,label21,label22 from template where name = '%@",template]; 
	[query appendString:@"'"];
	//	sql = [query cString];
	statement = nil;
	
	int nlabels = 0;
	// NSLog(@"query: %@",query);
	
	if(sqlite3_prepare_v2(db,[query cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)!= SQLITE_OK)
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(db));
	else
	{
		while(sqlite3_step(statement)==SQLITE_ROW) {
			nlabels = sqlite3_column_int(statement, 0);
			for (int i = 1; i <= nlabels; ++i) {
//				label = [[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)] autorelease];
				label = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, i)];
				[labels addObject:label];
			}
		}
		
	}
	
	sqlite3_finalize(statement);
	
	NSLog(@"finish loop 2");
	
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
	//	[HTMLString appendString:@"p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 60.0px; font: 60.0px Arial; }"];
	//	[HTMLString appendString:@"p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 18.0px; font: 24.0px Verdana;  min-height: 15.0px}"];
	[HTMLString appendString:@"body, ol, ul, li { margin: 24px; margin-top:0; margin-bottom:0;	padding: 0;  line-height: 60.0px; font: 60.0px Arial;} "];
	[HTMLString appendString:@"</style><body>"];
	//	[HTMLString appendString:@"<p class=""p1"">"];
	
	
	//	[HTMLString appendString:@"<body><meta name=""viewport"" content=""width=device-width; initial-scale=1.0; maximum-scale=1.0;"">"];
	//	[HTMLString appendString:@"<style> {padding: 0; line-height: 100%;		}</style>"];
	//	[HTMLString appendString:@"<FONT FACE=""arial"" SIZE=2>"];
	// Add Storage Life label for non-fruits and vegetables
	//	[HTMLString appendString:@"<style>body, ol, ul, li { margin: 9; margin-top:0; margin-bottom:0;	padding: 0; line-height: 100%;	}</style>"];
	
	if (!([template isEqualToString: @"Fresh Foods Fruits"] || [template isEqualToString: @"Fresh Foods Vegetables"]))
		[HTMLString appendString:@"<B>Storage Life</B><BR><BR>"];
	
	
	
//	if ([detail length] > 0 && !([detail isEqualToString:@"\"\""])) {
		for (int i = 0; i < nlabels; ++i) {
			NSLog(@"2nd LOOP %i",i);
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
		
//	}
//	else
//	{
/*	
		for (int i = 0; i < nlabels; ++i) {
//			[label release];
//			[detail release];
			label=[labels objectAtIndex:i];
			detail=[details objectAtIndex:i];
			if ([detail length] > 0 && !([detail isEqualToString:@"\"\""])) {
				[HTMLString appendString:label];						
				[HTMLString appendString:@"<UL>"];
				[HTMLString appendString:@"<LI>"];
				[HTMLString appendString:detail];
				[HTMLString appendString:@"</UL>"];
				[HTMLString appendString:@"</BR>"];
				
			}
		}
 */
//	}
	
	
	
	if (([template isEqualToString: @"Fresh Foods Fruits"] || [template isEqualToString: @"Fresh Foods Vegetables"])) {
		//		[HTMLString appendString:@"</FONT><FONT FACE=""arial"" SIZE=1>"];
		//		[HTMLString appendString:@"<style> p { line-height: 80%;	}</style>"];
		[HTMLString appendString:@"<BR><P>*Storage Life may vary as some fruits and vegetables may be more or less ripe when you purchase them.</P>"];				
	}
	
	[HTMLString appendString:@"</FONT>"];
	
	//	[HTMLString appendString:@"</p>"];
	[HTMLString appendString:@"</body></html>"];
	
	[self.webView loadHTMLString:HTMLString baseURL:[NSURL URLWithString:@""]];
	//NSLog(@"done webview ");
	
	

	//[details removeAllObjects];

	//[labels removeAllObjects];

	sqlite3_close(db);
	
	//Set the title of the navigation bar
	self.navigationItem.title = self.selectedProduce;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
	
}

- (void) willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
duration:(NSTimeInterval) duration {

	UIInterfaceOrientation toOrientation = self.interfaceOrientation;
	
	if (toOrientation == UIInterfaceOrientationPortrait || toOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		self.webView.frame = CGRectMake(20,17,280,382);
	}
	else
	{
		self.webView.frame = CGRectMake(30,11,420,246);
	}
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
