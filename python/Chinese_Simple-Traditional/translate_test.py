# coding: utf-8

import sys
import re
from langconv import *
reload(sys)
sys.setdefaultencoding('utf8')

#将简体转换成繁体
def simple2tradition(line):
    line = Converter('zh-hant').convert(line.decode('utf-8'))
    line = line.encode('utf-8')
    return line
# 将繁体转换成简体
def tradition2simple(line):
    line = Converter('zh-hans').convert(line.decode('utf-8'))
    line = line.encode('utf-8')
    return line
# 判断是否含有中文字符
def isChinese(query):
    line=query.decode('utf-8')
    if re.search(ur"[\u4e00-\u9fa5]+", line):
        # query=query.encode('utf-8')
        return True
    else:
        # query=query.encode('utf-8')
        return False
# 判断简繁体
def isSimpleChinese(query):
    line=query.encode('utf-8')
    simple=tradition2simple(line)
    if re.match(simple,line):
        return True
    else:
        return False


#test
#
#预定义字符
query1='clear the line comment symbol'
query2='清除该行注释符号'
query3='清除該行注釋符號'
line_simple='<>123asdasd把中文字符串进行繁体和简体中文的转换'
line_trans='<>123asdasd把中文字符串進行繁體和簡體中文的轉換'
line1=simple2tradition(line_simple)
line2=tradition2simple(line_simple)

# isChinese()函数
print('isChinese函数-------------------------')
query='23asdasd把中文字符串進行繁體和簡體中文的轉換book好不簡體'
query='23asdasd把中文字符串进行繁体和简体中文的转换book好不简体'
# query='china'
# query='简体'
# query='繁體'
if re.search(ur"[\u4e00-\u9fa5]+", query):
  print '{}'.format('query是中文:')
else:
  print '{}'.format('query不是中文:')

#re.match()
# print re.match(ur"[\u4e00-\u9fa5]+","啊")
# print re.match(ur"[\u4e00-\u9fa5]+",u"啊")
# print re.match(ur"[\u4e00-\u9fa5]+",u"t")
# print re.match(r"[\u4e00-\u9fa5]",tt.decode('utf8'))
# print re.match(ur"[\u4e00-\u9fa5]",tt.decode('utf8'))
# print re.match(ur".*[\u4e00-\u9fa5]+",u"hi,匹配到了")
# print re.match(ur".*[\u4e00-\u9fa5]+",u"hi,no no")
# print re.match(ur".*[\u4e00-\u9fa5]+","hi,匹配到了")
# print re.match(ur".*[\u4e00-\u9fa5]+","hi,no no")

#isSimpleChinese函数
print('isSimpleChinese函数--------------------')
print('line_simple:'+line_simple)
print('line1:'+line1)
print('line2:'+line2)
print(re.match(line2, line_simple))
if re.match(line2, line_simple):
  print '{0}{1}'.format('line_simple:','简体')
else:
  print '{0}{1}'.format('line_simple:','繁体')


#正式测试
print('正式测试------------------------------')
query=line_simple
# query=line_trans
# query=query1
print '{}{}'.format('字符内容:',query)
print '{}'.format('字符属性:')
dst='en'
query=query.decode('utf-8')
if isChinese(query):
    if isSimpleChinese(query):
        print('1:simChinese:'+dst)
    else:
        print('1:fanChinese!')
else:
    print('2:notChinese')