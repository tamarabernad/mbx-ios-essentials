/*
 
 Copyright (c) 2015 Tamara Bernad
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "MBXCoreDataStack.h"

@interface MBXCoreDataStack()
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation MBXCoreDataStack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance {
    static MBXCoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
+ (NSManagedObject *)createdEntityWithName:(NSString *)entityName{
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:[[MBXCoreDataStack sharedInstance] managedObjectContext]];
}
+ (NSManagedObject *) fetchEntity:(NSString *)entityName withUID:(NSString *)uid{
    NSManagedObjectContext *context = [[MBXCoreDataStack sharedInstance] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    [fetchRequest setPredicate:predicate];
    
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    return [result firstObject];
}
+ (NSManagedObject *)fetchEntity:(NSString *)entity WithPredicate:(NSPredicate *)predicate{
    NSManagedObjectContext *context = [[MBXCoreDataStack sharedInstance] managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entity inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setFetchLimit:1];
    
    if(predicate){
        [request setPredicate:predicate];
    }
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
    }
    return [array firstObject];
}
+ (NSArray *)fetchEntities:(NSString *)entity WithSortKey:(NSString *)sortKey Ascending:(BOOL)ascending WithPredicate:(NSPredicate *)predicate{
    NSArray *sortDescriptors = nil;
    if(sortKey){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:sortKey ascending:ascending];
        sortDescriptors = @[sortDescriptor];
    }
    
    return [MBXCoreDataStack fetchEntities:entity WithSortDescriptors:sortDescriptors WithPredicate:predicate];
    
}
+ (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [[MBXCoreDataStack sharedInstance] managedObjectContext];
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Error saving");
        }
    }
}

#pragma mark - helpers
+ (NSArray *)fetchEntities:(NSString *)entity WithSortDescriptors:(NSArray *)sortDescriptors WithPredicate:(NSPredicate *)predicate{
    NSManagedObjectContext *context = [[MBXCoreDataStack sharedInstance] managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entity inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    [request setSortDescriptors:sortDescriptors];
    
    if(predicate){
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (error != nil || array == nil)
    {
        NSLog(@"CoreDataStack::ErrorFeching::Entity %@ With Predicate: %@",entity, predicate);
    }
    return array;
}


#pragma mark - lazy getters
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyStoreTrumpMergePolicyType]];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BCCoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BCCoreDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil] error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
