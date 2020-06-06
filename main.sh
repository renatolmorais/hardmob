#!/bin/bash

keywords="keywords.txt"

if [ ! -f $keywords ]
then
	echo "faltou o arquivo $keywords"
	exit 1
fi

hardmoburl="https://www.hardmob.com.br/forums/407-Promocoes"
mainurl="https://www.hardmob.com.br"
urlfile="urls.txt"
md5urlfile="md5-$urlfile"

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

curl -k "$hardmoburl" 2> /dev/null | egrep -i "$regex" | grep -P 'href="(.*?)"' -o | cut -d" " -f1 | cut -d"=" -f2- | tr -d "\"" | sort | uniq | while read url
do
	promourl="$mainurl/$url"
	md5url=`echo $promourl | md5sum -t 2> /dev/null | tr -s " " | cut -d "-" -f1`
	retval="$(fgrep $md5url $md5urlfile > /dev/null 2>&1 ; echo $?)"
	if [ ! "$retval" = "0" ]
	then
		echo "Nova url encontrada..."
		echo "$promourl"
		echo $promourl >> $urlfile
		echo $md5url >> $md5urlfile
	fi
		
done
