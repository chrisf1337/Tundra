//
//  CDFManagingViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFManagingViewController.h"

@interface CDFManagingViewController ()

@end

@implementation CDFManagingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSURLConnection *)performRequestWithURLString:(NSString *)urlString
{
    NSString *requestString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [request setValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"ISO-8859-1,utf-8" forHTTPHeaderField:@"Accept-Charset"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36"
           forHTTPHeaderField:@"User-Agent"];
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
