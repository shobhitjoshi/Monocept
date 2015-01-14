//
//  NSURLConnection+BlockAddition.m
//  IRCTC SMS Booking
//
//  Created by Nanda Ballabh on 15/07/13.
//  Copyright (c) 2013 Monocept. All rights reserved.
//

#import "NSURLConnection+BlockAddition.h"
#import "WebResponse.h"

@interface NSURLConnectionBlockAdditionDelegate : NSObject
{
@private
    NSMutableData *receivedData;
    void (^completeBlock)(WebResponse *Response);
    int statusCode;
    NSHTTPURLResponse *httpResponse;
}
@property(strong,nonatomic) NSHTTPURLResponse *httpResponse;

- (id)initWithCompleteBlock:(void(^)(WebResponse *response))compelete;

@end

@implementation NSURLConnectionBlockAdditionDelegate
@synthesize httpResponse = _httpResponse;
- (id)initWithCompleteBlock:(void(^)(WebResponse *response))compelete
{
    self = [super init];
    if(self)
    {
        receivedData = [[NSMutableData alloc]init];
        completeBlock = [compelete copy];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        statusCode = [(NSHTTPURLResponse*)response statusCode];
        self.httpResponse = ((NSHTTPURLResponse*)response) ;
    }
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    WebResponse * response = [[WebResponse alloc] initWithStatusCode:statusCode withReceivedData:receivedData];
    response.httpResponse = httpResponse;
    NSString *recData = @"";
    if(receivedData!=nil)
        recData = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] ;
        
        IRLog(@"Response information: \n\n   Response information:\n\n   HTTP StatusCode: %i   HTTP URL: %@\n\n   HTTP HEADERS:  %@\n\n   HTTP DATA:     %@\n\n",
                 self.httpResponse.statusCode,
                 self.httpResponse.URL,
                 [self.httpResponse allHeaderFields],
                 recData);
        completeBlock(response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    WebResponse * response = [[WebResponse alloc] initWithStatusCode:statusCode withReceivedData:receivedData];
    [response setConnectionError:error];
    response.httpResponse = httpResponse;
    
    NSString *recData = @"";
    if(receivedData!=nil)
        recData = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        IRLog(@"Response information: \n\n   Response information:\n\n   HTTP StatusCode: %i   HTTP URL: %@\n\n   HTTP HEADERS:  %@\n\n   HTTP DATA:     %@\n\n",
                 ((NSHTTPURLResponse*)self.httpResponse).statusCode,
                 self.httpResponse.URL,
                 [((NSHTTPURLResponse*)self.httpResponse) allHeaderFields],
                 recData);
        completeBlock(response);
}

@end

@implementation NSURLConnection (BlockAddition)

+ (void)sendRequest:(NSURLRequest *)request completeBlock:( void (^)(WebResponse *response))complete
{
    id delegate = [[NSURLConnectionBlockAdditionDelegate alloc] initWithCompleteBlock:complete];
    [self connectionWithRequest:request delegate:delegate];
    NSString *postData = @"";
    if(request.HTTPBody!=nil)
        postData = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    
    IRLog(@"Request information: \n\n   Request information:\n\n   HTTP Method: %@  HTTP URL: %@\n\n   HTTP HEADERS:  %@\n\n   HTTP DATA:     %@\n\n",
             request.HTTPMethod,
             request.URL,
             [request allHTTPHeaderFields],
             postData);
}


@end