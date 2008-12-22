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

#import "PMPackageManager.h"
#import <alpm.h>
#import "PMRepository.h"

static PMPackageManager *_sharedManager = nil;

// TODO: Do we need to idiot proof like this? Do we keep this or +deallocate?
static void __attribute__((destructor)) __release_alpm()
{
	alpm_release();
}

@implementation PMPackageManager

#pragma mark Singleton bioilerplate

+ (PMPackageManager *) sharedManager
{
	@synchronized(self) {
		if(_sharedManager == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return _sharedManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if(_sharedManager == nil) {
			_sharedManager = [super allocWithZone:zone];
			return _sharedManager;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	if(self != nil) {
		_cacheDirectories = [NSMutableArray new];
		_repositories = [NSMutableArray new];
	}
	return self;
}

- (id) copyWithZone:(NSZone *)zone
{
	return self;
}

- (id) retain
{
	return self;
}

- (unsigned) retainCount
{
	return UINT_MAX;
}

- (void) release
{
	return;
}

- (id) autorelease
{
	return self;
}

#pragma mark Properties

- (NSString *)rootDirectory
{
	if(_rootDirectory == nil) {
		const char *root = alpm_option_get_root();
		_rootDirectory = [[NSString alloc] initWithUTF8String:root];
	}
	return _rootDirectory;
}

- (void)setRootDirectory:(NSString *)newPath
{
	if(_rootDirectory != newPath) {
		if(alpm_option_set_root([newPath UTF8String]) == 0) {
			[_rootDirectory release];
			_rootDirectory = [newPath copy];
		}
	}
}

- (NSString *)databasePath
{
	if(_databasePath == nil) {
		const char *dbpath = alpm_option_get_dbpath();
		_databasePath = [[NSString alloc] initWithUTF8String:dbpath];
	}
	return _databasePath;
}

- (void)setDatabasePath:(NSString *)newPath
{
	if(_databasePath != newPath) {
		if(alpm_option_set_dbpath([newPath UTF8String]) == 0) {
			[_databasePath release];
			_databasePath = [newPath copy];
		}
	}
}

- (NSArray *)cacheDirectories
{
	return [NSArray arrayWithArray:_cacheDirectories];
}

- (NSArray *) repositories
{
	return _repositories;
}

#pragma mark Public methods

+ (void) initialize
{
	alpm_initialize();
}

+ (void) deallocate
{
	alpm_release();
}

- (void) addCacheDirectory:(NSString *)thePath
{
	if(alpm_option_add_cachedir([thePath UTF8String]) == 0) {
		[_cacheDirectories addObject:thePath];
	}
}

- (void) removeCacheDirectory:(NSString *)thePath
{
	if(alpm_option_remove_cachedir([thePath UTF8String]) == 0) {
		[_cacheDirectories removeObject:thePath];
	}
}

- (PMRepository *) repositoryByRegisteringWithName:(NSString *)aName servers:(NSArray *)servers;
{
	PMRepository *repository;
	repository = [[PMRepository alloc] initWithName:aName servers:servers];
	[_repositories addObject:repository];
	return [repository autorelease];
}

- (void) addRepository:(PMRepository *)aRepository
{
	[_repositories addObject:aRepository];
}

- (void) removeRepository:(PMRepository *)aRepository
{
	[_repositories removeObject:aRepository];
}

- (void) refreshRepositories
{
	alpm_list_t *node;
	alpm_trans_init(PM_TRANS_TYPE_SYNC, 0, NULL, NULL, NULL);
	node = alpm_option_get_syncdbs();
	while(node != NULL) {
		alpm_db_update(0, alpm_list_getdata(node));
		node = alpm_list_next(node);
	}
	alpm_trans_release();
}

@end
