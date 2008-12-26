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

#import "PMTransaction.h"
#import <alpm.h>
#import "PMPackage.h"

@interface PMTransaction (Private)
- (void) _setFlag:(pmtransflag_t)flag;
- (void) _unsetFlag:(pmtransflag_t)flag;
- (void) _setOrUnsetFlag:(pmtransflag_t)flag dependingOnBool:(BOOL)value;
@end

@implementation PMTransaction

- (id) init
{
	self = [super init];
	if (self != nil) {
		_removeTargets = [NSMutableArray new];
		_syncTargets = [NSMutableArray new];
	}
	return self;
}

#pragma mark Properties


- (id) delegate
{
	return _delegate;
}

- (void) setDelegate:(id)anObject
{
	if(_delegate != anObject) {
		[_delegate release];
		_delegate = [anObject retain];
	}
}

- (BOOL) isForced
{
	return _flags && PM_TRANS_FLAG_FORCE;
}

- (void) setForced:(BOOL)forced
{
	[self _setOrUnsetFlag:PM_TRANS_FLAG_FORCE dependingOnBool:forced];
}

- (BOOL) isRecursive
{
	return _flags && PM_TRANS_FLAG_RECURSE;
}

- (void) setRecursive:(BOOL)recurse
{
	[self _setOrUnsetFlag:PM_TRANS_FLAG_RECURSE dependingOnBool:recurse];
}

- (BOOL) cascade
{
	return _flags && PM_TRANS_FLAG_CASCADE;
}

- (void) setCascade:(BOOL)cascade
{
	[self _setOrUnsetFlag:PM_TRANS_FLAG_CASCADE dependingOnBool:cascade];
}

- (BOOL) neededOnly
{
	return _flags && PM_TRANS_FLAG_NEEDED;
}

- (void) setNeededOnly:(BOOL)neededOnly
{
	[self _setOrUnsetFlag:PM_TRANS_FLAG_NEEDED dependingOnBool:neededOnly];
}

- (BOOL) downloadOnly
{
	return _flags && PM_TRANS_FLAG_DOWNLOADONLY;
}

- (void) setDownloadOnly:(BOOL)downloadOnly
{
	[self _setOrUnsetFlag:PM_TRANS_FLAG_DOWNLOADONLY dependingOnBool:downloadOnly];
}

#pragma mark Public methods

- (void) synchronizePackage:(PMPackage *)thePackage
{
	[_syncTargets addObject:thePackage];
}

- (void) removePackage:(PMPackage *)thePackage
{
	[_removeTargets removeObject:thePackage];
}

- (void) commit
{
	PMPackage *package;
	NSEnumerator *enumerator;
	alpm_list_t *conflicts;
	int status;

	// TODO: Refactor and set callbacks
	if([_removeTargets count] > 0) {
		status = alpm_trans_init(PM_TRANS_TYPE_REMOVE, _flags, NULL, NULL, NULL);
		NSAssert(status == 0, @"unable to initialise transaction");
		enumerator = [_removeTargets objectEnumerator];
		while((package = [enumerator nextObject]) != nil) {
			alpm_trans_addtarget((char *)[[package name] UTF8String]);
		}
		if(alpm_trans_prepare(&conflicts) != 0) {
			alpm_trans_release();
			NSAssert(0, @"unable to prepare transaction");
		}
		if(alpm_trans_commit(&conflicts) != 0) {
			alpm_trans_release();
			NSAssert(0, @"unable to commit transaction");
		}
		alpm_trans_release();
	}

	if([_syncTargets count] > 0) {
		status = alpm_trans_init(PM_TRANS_TYPE_UPGRADE, _flags, NULL, NULL, NULL);
		NSAssert(status == 0, @"unable to initialise transaction");
		enumerator = [_syncTargets objectEnumerator];
		while((package = [enumerator nextObject]) != nil) {
			alpm_trans_addtarget((char *)[[package name] UTF8String]);
		}
		if(alpm_trans_prepare(&conflicts) != 0) {
			alpm_trans_release();
			NSAssert(0, @"unable to prepare transaction");
		}
		if(alpm_trans_commit(&conflicts) != 0) {
			alpm_trans_release();
			NSAssert(0, @"unable to commit transaction");
		}
		alpm_trans_release();
	}
}

- (void) interrupt
{
	alpm_trans_interrupt();
}

#pragma mark Private methods

- (void) _setFlag:(pmtransflag_t)flag
{
	_flags |= flag;
}

- (void) _unsetFlag:(pmtransflag_t)flag
{
	_flags &= (~flag);
}

- (void) _setOrUnsetFlag:(pmtransflag_t)flag dependingOnBool:(BOOL)value
{
	if(value) {
		[self _setFlag:flag];
	} else {
		[self _unsetFlag:flag];
	}
}

@end
