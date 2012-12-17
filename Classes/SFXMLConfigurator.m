//
//  SFXMLParser.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFXMLConfigurator.h"
#import "SFObjectPattern.h"

@interface SFXMLConfigurator ()

@property(nonatomic,retain) SFObjectPattern * objectPattern;

@property(nonatomic,retain) NSMutableDictionary * values;
@property(nonatomic,retain) NSMutableDictionary * refBeans;

@property(nonatomic,retain) NSMutableArray * arrayValue;
@property(nonatomic,retain) NSMutableDictionary * mapValue;
@property(nonatomic,retain) NSString * propertyName;

@end

@implementation SFXMLConfigurator
- (void)dealloc
{
    TT_RELEASE_SAFELY(_xmlData);
    TT_RELEASE_SAFELY(_parseError);
    TT_RELEASE_SAFELY(_objectPattern);
    TT_RELEASE_SAFELY(_values);
    TT_RELEASE_SAFELY(_refBeans);
    TT_RELEASE_SAFELY(_arrayValue);
    TT_RELEASE_SAFELY(_mapValue);
    TT_RELEASE_SAFELY(_propertyName);
    [super dealloc];
}

- (id)initWithData:(NSData *) data
{
    self = [super init];
    if (self) {
        self.xmlData = data;
    }
    return self;
}

-(BOOL)startConfig
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:self.xmlData]; //设置XML数据
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
    return !_parseError;
}

#pragma mark - NSXMLParserDelegate
//发现元素开始符的处理函数  （即报告元素的开始以及元素的属性）
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //解析到BEAN标签则初始化数据
    if ([[elementName uppercaseString] isEqualToString:@"BEAN"]) {
        [self parseBeanWithAttributes:attributeDict];
    }
    if([[elementName uppercaseString] isEqualToString:@"PROPERTY"]){
        [self parsePropertyWithAttributes:attributeDict];
    }
    /////////////////////////////////////////////////////////////////////////////////////
    
    if ([[elementName uppercaseString] isEqualToString:@"ARRAY"]) {
        [self parseArray];
    }
    if ([[elementName uppercaseString] isEqualToString:@"MAP"]) {
        [self parseMap];
    }
    /////////////////////////////////////////////////////////////////////////////////////
    if ([[elementName uppercaseString] isEqualToString:@"ITEM"]) {
        if (!self.arrayValue) {
            [parser parserError];
        }
        [self.arrayValue addObject:[self parseValue:[attributeDict objectForKey:@"value"]]];
    }
    if ([[elementName uppercaseString] isEqualToString:@"ELEMENT"]) {
        if (!self.mapValue) {
            [parser parserError];
        }
        [self.mapValue setValue:[self parseValue:[attributeDict objectForKey:@"value"]] forKey:[attributeDict objectForKey:@"key"]];
    }
}

//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([[elementName uppercaseString] isEqualToString:@"BEAN"]) {
        self.values = nil;
        self.refBeans = nil;
        self.objectPattern = nil;
    }
    if([[elementName uppercaseString] isEqualToString:@"PROPERTY"]){
        self.propertyName = nil;
    }
    if ([[elementName uppercaseString] isEqualToString:@"ARRAY"]) {
        self.arrayValue = nil;
    }
    if ([[elementName uppercaseString] isEqualToString:@"MAP"]) {
        self.mapValue = nil;
    }
}

//报告不可恢复的解析错误
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    TTDPRINT(@"%@ \n line:%i \n publicID:%@ \n systemID:%@",parseError,parser.lineNumber,parser.publicID,parser.systemID);
    _parseError = [parseError retain];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark private
-(void)parseBeanWithAttributes:(NSDictionary *) attributeDict
{
    NSString * copiedObjectId = [attributeDict objectForKey:@"copy"];
    NSString * sharedObjectId = [attributeDict objectForKey:@"share"];
    NSString * identifier = [attributeDict objectForKey:@"id"];
    NSString * createURL = [attributeDict objectForKey:@"create-url"];
    SFObjectMode mode = [[attributeDict objectForKey:@"mode"] isEqualToString:@"create"]?SFObjectModeCreate:SFObjectModeShare;
    //guard
    if (!(identifier && createURL)&& !copiedObjectId && !sharedObjectId) {
        _parseError = [[NSError alloc]initWithDomain:@"bean Error" code:9 userInfo:@{NSLocalizedDescriptionKey : @"bean has no Id or url"}];
        return;
    }
    if(sharedObjectId){
        [self.delegate setPattern:[self.delegate objectPatternForIdentifier:sharedObjectId]
                    forIdentifier:identifier];
        self.objectPattern = nil;
        return;
    }
    if (copiedObjectId) {
        self.objectPattern = [[[self.delegate objectPatternForIdentifier:copiedObjectId] copy] autorelease];
        self.values = (NSMutableDictionary *)[self.objectPattern values];
        self.refBeans = (NSMutableDictionary *)[self.objectPattern beans];
    }else{
        self.objectPattern = [SFObjectPattern patternWithURL:createURL
                                              propertyValues:nil
                                            propertyRefBeans:nil
                                                  objectMode:mode];
    }
    [self.delegate setPattern:self.objectPattern forIdentifier:identifier];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)parsePropertyWithAttributes:(NSDictionary *) attributeDict
{
    if (self.objectPattern) {
        NSString * attribute = nil;
        NSString * name = [attributeDict objectForKey:@"name"];
        if ((attribute = [attributeDict objectForKey:@"value"])) {
            [self.values setValue:[self parseValue:attribute] forKey:name];
            [self.objectPattern setValues:self.values];
        }
        if ((attribute = [attributeDict objectForKey:@"ref"])) {
            [self.refBeans setValue:attribute forKey:name];
            [self.objectPattern setBeans:self.refBeans];
        }
        self.propertyName = name;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)parseArray
{
    if (self.propertyName) {
        self.arrayValue = [NSMutableArray array];
        [self.values setValue:self.arrayValue forKey:self.propertyName];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)parseMap
{
    if (self.propertyName) {
        self.mapValue = [NSMutableDictionary dictionary];
        [self.values setValue:self.mapValue forKey:self.propertyName];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)parseValue:(NSString *) value
{
    if ([[value uppercaseString]isEqualToString:@"TRUE"]) {
        return [NSNumber numberWithBool:YES];
    }
    if ([[value uppercaseString]isEqualToString:@"FALSE"]) {
        return [NSNumber numberWithBool:NO];
    }
    if ([value hasSuffix:@"f"]) {
        NSString * number = [value substringToIndex:value.length - 1];
        return [NSNumber numberWithDouble:[number doubleValue]];
    }
    return value;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark override
-(NSMutableDictionary *)values
{
    if (!_values) {
        self.values = [NSMutableDictionary dictionary];
    }
    return _values;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSMutableDictionary *)refBeans
{
    if (!_refBeans) {
        self.refBeans = [NSMutableDictionary dictionary];
    }
    return _refBeans;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
