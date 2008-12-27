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

#import "PMPackage.h"
#import <alpm.h>
#import <alpm_list.h>
#import <string.h>
#import "PMDatabase.h"
#import "PMPackagePrivate.h"

#define kLocalDatabaseName "local"

@implementation PMPackage

- (id) initWithName:(NSString *)aName fromDatabase:(PMDatabase *)theDatabase
{
	alpm_list_t *node;
	pmdb_t *db = NULL;
	pmdb_t *tmpdb;
	const char *dbname = [[theDatabase name] UTF8String];
	const char *pkgname = [aName UTF8String];

	// This is stupid, PMDatabase has a reference to the pmdb_t
	if(strcmp(dbname, kLocalDatabaseName) == 0) {
		db = alpm_option_get_localdb();
	} else {
		node = alpm_option_get_syncdbs();
		while(node != NULL && db == NULL) {
			tmpdb = alpm_list_getdata(node);
			if(strcmp(dbname, alpm_db_get_name(tmpdb)) == 0) {
				db = tmpdb;
			}
			node = alpm_list_next(node);
		}
	}
	self = [self _initUsingALPMPackage:alpm_db_get_pkg(db, pkgname)];
	if(self != nil) {
		_database = [theDatabase retain];
	}
	return self;
}

- (id) initWithContentsOfURL:(NSURL *)theURL
{
	NSString *filePath;
	if(![theURL isFileURL]) {
		char *path = alpm_fetch_pkgurl([[theURL path] UTF8String]);
		if(path == NULL) {
			return nil;
		}
		filePath = [[NSString alloc] initWithUTF8String:path];
		free(path);
	} else {
		filePath = [theURL path];
	}
	return [self initWithContentsOfFile:filePath];
}

- (id) initWithContentsOfFile:(NSString *)aFilePath
{
	pmpkg_t *package;
	if(alpm_pkg_load([aFilePath UTF8String], 0, &package) != 0) {
		return nil;
	}
	self = [self _initUsingALPMPackage:package];
	return self;
}

- (void) dealloc
{
	[_database release];
	[_filename release];
	[_name release];
	[_packager release];
	[_version release];
	[_size release];
	[_description release];
	[_url release];
	[super dealloc];
}

- (NSString *) packager
{
	if(_packager == nil) {
		_packager = [[NSString alloc] initWithUTF8String:alpm_pkg_get_packager(_package)];
	}
	return _packager;
}

- (NSNumber *) size
{
	if(_size == nil) {
		unsigned long long size = alpm_pkg_get_size(_package);
		_size = [[NSNumber alloc] initWithUnsignedLongLong:size];
	}
	return _size;
}

- (NSString *) description
{
	if(_description == nil) {
		_description = [[NSString alloc] initWithUTF8String:alpm_pkg_get_desc(_package)];
	}
	return _description;
}

- (NSURL *) url
{
	if(_url == nil) {
		NSString *url = [[NSString alloc] initWithUTF8String:alpm_pkg_get_url(_package)];
		_url = [[NSURL alloc] initWithString:url];
		[url release];
	}
	return _url;
}

- (NSString *)name
{
	return _name;
}

- (NSString *)version
{
	return _version;
}

- (PMDatabase *)database
{
	return _database;
}

- (NSString *)filename
{
	return _filename;
}

- (BOOL) isInstalled
{
	pmdb_t *local = alpm_option_get_localdb();
	const char *pkgName = alpm_pkg_get_name(_package);
	return alpm_db_get_pkg(local, pkgName) != NULL;
}

@end
