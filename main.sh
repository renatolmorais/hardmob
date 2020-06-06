#!/bin/bash

config_file="config.sh"

if [ ! -f $config_file ]
then
	echo "faltou o arquivo de configuracao $config_file"
	exit 1
else
	. $config_file
fi

keywords="keywords.txt"

if [ ! -f $keywords ]
then
	echo "faltou o arquivo $keywords"
	exit 2
fi

hardmoburl="https://www.hardmob.com.br/forums/407-Promocoes"
mainurl="https://www.hardmob.com.br"
urlfile="urls.txt"
md5urlfile="md5-$urlfile"
mailfile="email.txt"
[[ -f $mailfile ]] && rm -f $mailfile

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

curl $socks -k "$hardmoburl" 2> /dev/null | egrep -i "$regex" | grep -P 'href="(.*?)"' -o | cut -d" " -f1 | cut -d"=" -f2- | tr -d "\"" | sort | uniq | while read url
do
	promourl="$mainurl/$url"
	md5url=`echo $promourl | md5sum -t 2> /dev/null | tr -s " " | cut -d "-" -f1`
	retval="$(fgrep $md5url $md5urlfile > /dev/null 2>&1 ; echo $?)"
	if [ ! "$retval" = "0" ]
	then
		echo "Nova url encontrada..."
		echo "$promourl"
		echo $promourl >> $urlfile
		echo $promourl >> $mailfile
		echo $md5url >> $md5urlfile
	fi
		
done

# se vc tem um script par enviar e-mails, coloque aí embaixo
mailscript="sendmail.py"
if [ -f $mailfile -a -f $mailscript ]
then
	/usr/bin/python $mailscript "renatolmorais@gmail.com" "Novas URLs encontradas!" $mailfile
fi

