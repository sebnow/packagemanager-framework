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

#import "NSArrayALPMListExtensions.h"
#import "PMPackagePrivate.h"
#import "PMDatabasePrivate.h"

@implementation NSArray (alpm_list_t)
+ (id) arrayWithPackageList:(alpm_list_t *)aList database:(PMDatabase *)theDatabase
{
	NSMutableArray *tmp;
	NSArray *array;
	tmp = [[NSMutableArray alloc] initWithPackageList:aList database:theDatabase];
	array = [NSArray arrayWithArray:tmp];
	[tmp release];
	return array;
}

+ (id) arrayWithDatabaseList:(alpm_list_t *)aList
{
	NSMutableArray *tmp;
	NSArray *array;
	tmp = [[NSMutableArray alloc] initWithDatabaseList:aList];
	array = [NSArray arrayWithArray:tmp];
	[tmp release];
	return array;
}
@end

@implementation NSMutableArray (alpm_list_t)
- (id) initWithPackageList:(alpm_list_t *)aList database:(PMDatabase *)theDatabase
{
	self = [self initWithCapacity:alpm_list_count(aList)];
	if(self != nil) {
		alpm_list_t *node;
		PMPackage *package;

		node = aList;
		while(node != NULL) {
			package = [[PMPackage alloc] _initUsingALPMPackage:alpm_list_getdata(node) database:theDatabase];
			[self addObject:package];
			[package release];
			node = alpm_list_next(node);
		}
	}
	return self;
}

- (id) initWithDatabaseList:(alpm_list_t *)aList
{
	self = [self initWithCapacity:alpm_list_count(aList)];
	if(self != nil) {
		alpm_list_t *node;
		PMDatabase *database;

		node = aList;
		while(node != NULL) {
			database = [[PMDatabase alloc] _initUsingALPMDatabase:alpm_list_getdata(node)];
			[self addObject:database];
			[database release];
			node = alpm_list_next(node);
		}
	}
	return self;
}
@end
