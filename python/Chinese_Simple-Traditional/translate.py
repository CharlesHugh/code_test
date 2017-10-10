# coding: utf-8
import argparse
import os
import sys
import requests
import re
from urllib import unquote
from googletrans import Translator
from langconv import *

reload(sys)
sys.setdefaultencoding('utf8')

parser = argparse.ArgumentParser()
parser.add_argument('query', nargs='?', default=None)
parser.add_argument('--site', dest='site', nargs='?', default=None)
parser.add_argument('--lang', dest='lang', nargs='?', default=None)
parser.add_argument('--toclipboard', dest='toclipboard', nargs='?', default=None)
parser.add_argument('--location', dest='location', nargs='?', default=None)
args = parser.parse_args()

site = args.site
lang = args.lang
toclipboard = args.toclipboard
location = args.location

query = unquote(args.query)#去除括号
query = query.decode('utf-8')

def shelloutput(result, toclipboard, location):
    os.environ['result'] = result
    if location == 'topright':
        shell = 'exec ./dialog/Contents/MacOS/cocoaDialog bubble \
                --title "翻译结果" \
                --icon-file gt.png \
                --text "$result"'
    else:
        shell = 'rv=`./dialog/Contents/MacOS/cocoaDialog msgbox \
            --title "Google Translate" \
            --text "翻译结果" \
            --icon-file gt.png \
            --informative-text "$result" \
            --button1 "OK" --button3 "复制结果"` '
        shell = shell + '\n if [ "$rv" == "3" ]; then echo "$result" | /usr/bin/pbcopy ;fi'
    os.system(shell)
    if toclipboard == '1':
        os.system('echo "$result" |/usr/bin/pbcopy')

def erroroutput():
    shell = 'exec ./dialog/Contents/MacOS/cocoaDialog bubble \
        --title "Something Went Wrong" \
        --icon-file error.png \
        --text "我也不知道发生了什么..."'
    os.system(shell)

def hahaha():
    shell = 'exec ./dialog/Contents/MacOS/cocoaDialog bubble \
        --title "你居然真的选了瓦雷利亚语😂" \
        --icon-file haha.png \
        --text "哈哈哈，怎么可能有瓦雷利亚语的翻译啊，你是权游看多了吧233333"'
    os.system(shell)

# 判断是否含有中文字符
def isChinese(query):
    chinese=query.decode('utf-8')
    if re.search(ur"[\u4e00-\u9fa5]+", chinese):
        return True
    else:
        return False
# 将繁体转换成简体
def tradition2simple(query):
    query = Converter('zh-hans').convert(query.decode('utf-8'))
    query = query.encode('utf-8')
    return query
# 判断繁体简体
def isSimpleChinese(query):
    line=query.encode('utf-8')
    simple=tradition2simple(line)
    if re.match(simple,line):
        return True
    else:
        return False

def translate(query, dest='zh-CN'):
    if site == 'translate.google.cn':
        service_urls = ['translate.google.cn']
    elif site == 'translate.google.com':
        service_urls = ['translate.google.com']
    translator = Translator(service_urls=service_urls)  # 国内用户不用翻墙
    result = translator.translate(query, dest=dest)
    return result.text

if lang  == 'English':
    dst = 'en'
elif lang == 'German':
    dst = 'de'
elif lang == 'Korean':
    dst = 'ko'
elif lang == 'Japanese':
    dst = 'ja'
elif lang == 'French':
    dst = 'fr'
elif lang == 'Russian':
    dst == 'ru'
elif lang == 'Latin':
    dst == 'la'
elif lang == 'Spanish':
    dst = 'es'
elif lang == 'Italian':
    dst = 'it'
elif lang == 'Valyrian':
    hahaha()
    exit()

if not query:
    erroroutput()
else:
    if isChinese(query):
        if isSimpleChinese(query):
            shelloutput(translate(query, dst), toclipboard, location)
        else:
            shelloutput(translate(query), toclipboard, location)
    else:
        shelloutput(translate(query), toclipboard, location)

