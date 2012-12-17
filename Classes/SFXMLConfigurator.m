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

@end

@implementation SFXMLConfigurator
- (void)dealloc
{
    TT_RELEASE_SAFELY(_xmlData);
    TT_RELEASE_SAFELY(_parseError);
    TT_RELEASE_SAFELY(_objectPattern);
    TT_RELEASE_SAFELY(_values);
    TT_RELEASE_SAFELY(_refBeans);
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
        [self parseObjectPatternWithAttributes:attributeDict];
    }
    if([[elementName uppercaseString] isEqualToString:@"PROPERTY"]){
        [self parsePropertiesWithAttributes:attributeDict];
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    if ([[elementName uppercaseString] isEqualToString:@"ARRAY"]) {
        self.arrayValue = [NSMutableArray array];
    }
    if ([[elementName uppercaseString] isEqualToString:@"MAP"]) {
        self.mapValue = [NSMutableDictionary dictionary];
    }
    if ([[elementName uppercaseString] isEqualToString:@"LIST"]) {
        TTDASSERT(self.arrayValue);
        [self.arrayValue addObject:[self parseValue:[attributeDict objectForKey:@"value"]]];
    }
    if ([[elementName uppercaseString] isEqualToString:@"ELEMENT"]) {
        TTDASSERT(self.mapValue);
        [self.arrayValue setValue:[self parseValue:[attributeDict objectForKey:@"value"]] forKey:[attributeDict objectForKey:@"key"]];
    }
}

//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //TODO:should set all properties nil?
}

//报告不可恢复的解析错误
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    TTDPRINT(@"%@",parseError);
    _parseError = [parseError retain];
}

#pragma -mark private
-(void)parseObjectPatternWithAttributes:(NSDictionary *) attributeDict
{
    NSString * copiedObjectId = [attributeDict objectForKey:@"copy"];
    NSString * sharedObjectId = [attributeDict objectForKey:@"share"];
    NSString * identifier = [attributeDict objectForKey:@"id"];
    NSString * createURL = [attributeDict objectForKey:@"create-url"];
    SFObjectMode mode = [[attributeDict objectForKey:@"mode"] isEqualToString:@"create"]?SFObjectModeCreate:SFObjectModeShare;
    
    if (copiedObjectId) {
        //复制参数
        self.objectPattern = [[[self.delegate objectPatternForIdentifier:copiedObjectId] copy] autorelease];
        [self.delegate setPattern:self.objectPattern forIdentifier: identifier];
        
    }else if(sharedObjectId){
        [self.delegate setPattern:[self.delegate objectPatternForIdentifier:copiedObjectId] forIdentifier:identifier];
    }else{
        self.values = [NSMutableDictionary dictionary];
        self.refBeans = [NSMutableDictionary dictionary];
        self.objectPattern = [SFObjectPattern patternWithURL:createURL
                                              propertyValues:self.values
                                            propertyRefBeans:self.refBeans
                                                  objectMode:mode];
        [self.delegate setPattern:self.objectPattern forIdentifier:identifier];
    }
    
}

-(void)parsePropertiesWithAttributes:(NSDictionary *) attributeDict
{
    NSString * attribute = nil;
    NSString * name = [attributeDict objectForKey:@"name"];
    if ((attribute = [attributeDict objectForKey:@"value"])) {
        [self.values setValue:[self parseValue:attribute] forKey:name];
    }
    if ((attribute = [attributeDict objectForKey:@"ref"])) {
        [self.refBeans setValue:attribute forKey:name];
    }
    if (self.mapValue) {
        [self.values setValue:self.mapValue forKey:name];
    }
    if (self.arrayValue) {
        [self.values setValue:self.arrayValue forKey:name];
    }
}

-(id)parseValue:(NSString *) value
{
    if ([[value uppercaseString]isEqualToString:@"TRUE"]) {
        return [NSNumber numberWithBool:YES];
    }
    if ([[value uppercaseString]isEqualToString:@"FALSE"]) {
        return [NSNumber numberWithBool:NO];
    }
    return value;
}

@end
