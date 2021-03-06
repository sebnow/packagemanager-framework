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

#import "PMDatabase.h"
#import <alpm.h>
#import "PMPackage.h"
#import "PMPackagePrivate.h"
#import "NSArrayALPMListExtensions.h"

@implementation PMDatabase

- (void) dealloc
{
	alpm_db_unregister(_database);
	[super dealloc];
}

- (NSString *) name
{
	return _name;
}

- (NSArray *) packages
{
	alpm_list_t *list;
	list = alpm_db_getpkgcache(_database);
	return [NSArray arrayWithPackageList:list database:self];
}

- (NSArray *) filteredPackagesUsingPredicate:(NSPredicate *)thePredicate
{
	NSArray *packages = [self packages];
	return [packages filteredArrayUsingPredicate:thePredicate];
}

- (PMPackage *) packageWithName:(NSString *)aName
{
	NSPredicate *predicate;
	NSArray *results;
	PMPackage *package = nil;
	predicate = [NSPredicate predicateWithFormat:@"SELF.name == %@", aName];
	results = [[self packages] filteredArrayUsingPredicate:predicate];
	if([results count] > 0) {
		package = [results objectAtIndex:0];
	}
	return package;
}

@end
