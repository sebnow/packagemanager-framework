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

#import "PMLocalDatabase.h"
#import <alpm.h>

@implementation PMLocalDatabase

#pragma mark Singleton bioilerplate

static PMLocalDatabase *_sharedDatabase = nil;

+ (PMLocalDatabase *) sharedDatabase
{
	@synchronized(self) {
		if(_sharedDatabase == nil) {
			[[self alloc] init];
		}
	}
	return _sharedDatabase;
}

+ (id) allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if(_sharedDatabase == nil) {
			_sharedDatabase = [super allocWithZone:zone];
			return _sharedDatabase;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	if(self) {
		_database = alpm_db_register_local();
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

@end
