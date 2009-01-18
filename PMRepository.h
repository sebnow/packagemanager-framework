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

#import <Foundation/Foundation.h>
#import "PMDatabase.h"

/** A notification sent before a repository is refreshed.
 The notification object is the PMRepository which will be refreshed. */
extern NSString *const PMRepositoryWillRefreshNotification;

/** A notification sent after a respository is refreshed.
 The notification object is the PMRepository which was refreshed. */
extern NSString *const PMRepositoryDidRefreshNotification;

/** A remote database containing a collection of packages
 A repository has one or more servers, and these must be added before packages
 can be retrieved from the repository. This can be done using the
 #initWithName:servers:, or by adding each server manually using
 #addServerWithURL:. When there is at least one server registered, the #refresh
 message should be sent to retrieve the package list from the server.
 */
@interface PMRepository : PMDatabase {
	/** Array of servers to be used when retrieving packages */
	NSMutableArray *_servers;
}

/** Initialize a remote repository with the specified name
 @param aName the name of the repository
 */
- (id) initWithName:(NSString *)aName;

/** Initialize a remote repository with the specified name and servers
 @param aName the name of the repository
 @param theServers an array of servers the repository will use
 */
- (id) initWithName:(NSString *)aName servers:(NSArray *)theServers;

/** Add a server to the repository.
 @param theURL a URL pointing to a server
 */
- (void) addServerWithURL:(NSURL *)theURL;

/** Retrieve a new list of packages.
 Each server will be used in turn. If the first server fails, the second will
 be used, and so on.
 */
- (void) refresh;

/** Force the retrieval of a new list of packages.
 The list of packages will be retrieved regardless of whether the repository is
 up to date or not. */
- (void) forceRefresh;

/** Return the array of servers.
 @return array of servers */
- (NSArray *) servers;

@end
