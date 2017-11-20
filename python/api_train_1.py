#!/usr/bin/python
# encoding:utf-8
 
import urllib2, json, urllib, time
 
 
# 2、车次查询
 
 
data = {}
data["appkey"] = "b2d0769f82642a77"
data["trainno"] = "G34"
url_values = urllib.urlencode(data)
url = "http://api.jisuapi.com/train/line" + "?" + url_values
request = urllib2.Request(url)
result = urllib2.urlopen(request)
jsonarr = json.loads(result.read())
 
if jsonarr["status"] != u"0":
    print jsonarr["msg"]
    exit()
result = jsonarr["result"]
print result["trainno"],result["type"]
for val in result["list"]:
    print val["sequenceno"],val["station"],val["arrivaltime"],val["departuretime"],val["stoptime"]

import json,requests 
r = requests.get('https://www.v2ex.com/api/topics/hot.json') 
print(r.json())
print(r)