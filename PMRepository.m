/*
 * Copyright (c) 2008 Sebastian Nowicki <sebnow@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import "PMRepository.h"
#import "PMDatabasePrivate.h"
#import <alpm.h>

NSString *const PMRepositoryWillRefreshNotification = @"PMRepositoryWillRefreshNotification";
NSString *const PMRepositoryDidRefreshNotification = @"PMRepositoryDidRefreshNotification";

@implementation PMRepository

- (id) initWithName:(NSString *)aName
{
	return [self initWithName:aName servers:nil];
}

- (id) initWithName:(NSString *)aName servers:(NSArray *)theServers
{
	pmdb_t *db = alpm_db_register_sync([aName UTF8String]);
	self = [super _initUsingALPMDatabase:db];
	if(self != nil) {
		if(theServers == nil) {
			_servers = [NSMutableArray new];
		} else {
			_servers = [[NSMutableArray alloc] initWithArray:theServers];
		}
	}
	return self;
}

- (void) dealloc
{
	[_servers release];
	[super dealloc];
}

- (void) addServerWithURL:(NSURL *)theURL
{
	const char *urlUTF8 = [[theURL absoluteString] UTF8String];
	int status;
	status = alpm_db_setserver(_database, urlUTF8);
	NSAssert(status == 0, @"database not registered");
	[_servers addObject:theURL];
}

- (void) refresh
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PMRepositoryWillRefreshNotification object:self];
	alpm_db_update(0, _database);
	[[NSNotificationCenter defaultCenter] postNotificationName:PMRepositoryDidRefreshNotification object:self];
}

- (void) forceRefresh
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PMRepositoryWillRefreshNotification object:self];
	alpm_db_update(1, _database);
	[[NSNotificationCenter defaultCenter] postNotificationName:PMRepositoryDidRefreshNotification object:self];
}

- (NSArray *) servers
{
	return _servers;
}

@end
