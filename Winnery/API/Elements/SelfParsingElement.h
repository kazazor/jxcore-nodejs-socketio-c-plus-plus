//
//  SelfParsingElement.h
//  Winery
//
//  Created by Nilit Rokah on 11/11/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Defines all the basic element functionality for item's parsing and validation.
 */
@interface SelfParsingElement : NSObject
{
    
}

/**
 * A template method that impelements the JSON parsing of the element.
 *
 * The dictionary from the element is parsed and saved in the different element's
 * class properties.
 *
 * The children of this class will have to implement this method in order to parse
 * relevant fields.
 *
 * @param   element      An element to parse.
 */
- (void)fillWithJSONElement:(id)element;

/**
 * A template method that creates a JSON dictionary string of the element class fields.
 *
 * The children of this class will have to implement this method in order to create
 * a JSON string from the relevant fields.
 *
 * @return   A string that holds the JSON dictionary.
 */
- (NSString *)json;

/**
 * A method that creates a JSON dictionary of the element class fields.
 *
 * @return   A JSON dictionary.
 */
- (NSDictionary *)jsonDictionary;

/**
 * A method that gets an object from an element according to a given key.
 *
 * @param   element         The element that should be parsed.
 * @param   key             The key that should be searched in the element.
 * @param   defaultValue    The object that should be returned from the function in case
 *                          the object found was nil.
 * @return  The found object or given default value.
 */
- (NSObject *)getObjectFromKey:(id)element key:(NSString *)key defaultValue:(NSObject *)defaultValue;

/**
 * A method that gets an object from an element according to a given key.
 *
 * @param   element         The element that should be parsed.
 * @param   key             The key that should be searched in the element.
 * @return  The found object or nil.
 */
- (NSObject *)getObjectFromKey:(id)element key:(NSString *)key;

/**
 * A method that gets a string from an element, according to a given key, only if the
 * element's class type is NSDictionary.
 *
 * @param   element         The element that should be parsed.
 * @param   key             The key that should be searched in the element.
 * @return  The found string or nil.
 */
- (NSString *)getStringFromKey:(id)element key:(NSString *)key;

/**
 * A method that checks the status of an object. In the case that the object is nil
 * the method will return @"null" string.
 *
 * @param   val The object to be checked.
 * @return  The given object or @"null".
 */
- (NSObject *)validateObject:(NSObject *)val;

@end
