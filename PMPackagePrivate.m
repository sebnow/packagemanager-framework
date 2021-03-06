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

#import "PMPackagePrivate.h"
#import "PMDatabasePrivate.h"

@implementation PMPackage (Private)
- (id) _initUsingALPMPackage:(pmpkg_t *)aPackage
{
	self = [super init];
	if(self != nil) {
		_package = aPackage;
		// These fields are already retrieved from the database
		_name = [[NSString alloc] initWithUTF8String:alpm_pkg_get_name(_package)];
		_version = [[NSString alloc] initWithUTF8String:alpm_pkg_get_version(_package)];
		_filename = [[NSString alloc] initWithUTF8String:alpm_pkg_get_filename(_package)];
	}
	return self;
}

- (id) _initUsingALPMPackage:(pmpkg_t *)aPackage database:(PMDatabase *)aDatabase
{
	self = [self _initUsingALPMPackage:aPackage];
	if(self != nil) {
		_database = [aDatabase retain];
	}
	return self;
}
@end
