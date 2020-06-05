#!/bin/bash

hardmoburl="https://www.hardmob.com.br/forums/407-Promocoes"
urlfile="urls.txt"
md5urlfile="md5-$urlfile"
#md5pagefile="html-md5-$urlfile"

regex=`cat keywords.txt  | awk '
BEGIN {
        IRS = "\n" ;
        IFS = " " ;
        ORS = "";
}
{
        if (NR > 1)
        {
                print "|"
                print $1
        }
        else
        {
		print "("
                print $1
        }
}
END {
	print ")"
}
'`

found="0"
curl -k "$hardmoburl" 2> /dev/null | egrep -i "$regex" | grep -P 'href="(.*?)"' -o | cut -d" " -f1 | cut -d"=" -f2- | tr -d "\"" | sort | uniq | while read url
#curl -k "$hardmoburl" 2> /dev/null | egrep -i "$regex" | grep -P 'href="(.*?)"' -o | cut -d" " -f1 | cut -d"=" -f2- | tr -d "\"" | while read url
do
	promourl="$hardmoburl/$url"
	#md5page="$(curl -k $promourl 2> /dev/null | md5sum -t 2> /dev/null | tr -s " " | cut -d "-" -f1)"
	md5url=`echo $promourl | md5sum -t 2> /dev/null | tr -s " " | cut -d "-" -f1`
	retval="$(fgrep $md5url $md5urlfile > /dev/null 2>&1 ; echo $?)"
	#retval="$(fgrep $md5page $md5pagefile > /dev/null 2>&1 ; echo $?)"
	if [ ! "$retval" = "0" ]
	then
		echo "Nova url encontrada..."
		echo "$promourl"
		echo $promourl >> $urlfile
		echo $md5url >> $md5urlfile
		found="1"
	fi
		
done
