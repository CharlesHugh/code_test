#!/bin/sh
#对变量赋值：
a="hello world"
# 现在打印变量a的内容：
echo "A is:"
echo $a
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"

echo $greeting $greeting_1

# LIST=$(find /Applications -maxdepth 2 | egrep -i "\.app$" | grep -i "$QUERY")

# 	echo '<?xml version="1.0"?><items>
# 		<item>
# 			<arg>online^'$QUERY'</arg>
# 			<title>Search app icons online</title>
# 			<subtitle>Switch to online search in App Store and Mac App Store</subtitle>
# 		</item>'
# 	while IFS= read -r line
# 	do
# 	appnm=$(basename "$line" | sed 's|.app||g')
# 	echo '<item>
# 			<arg>'$line'</arg>
# 			<title>'$appnm'</title>
# 			<icon type="fileicon">'$line'</icon>
# 		</item>'
# 	done <<< "$LIST"
# 	echo '</items>'

