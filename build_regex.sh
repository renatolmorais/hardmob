#!/bin/bash

apppath="/usr/local/hardmob"

config_file="config.sh"

if [ ! -f "$apppath/$config_file" ]
then
        echo "faltou o arquivo de configuracao $config_file"
        exit 1
else
        . "$apppath/$config_file"
fi

keywords="keywords.txt"

if [ ! -f "$apppath/$keywords" ]
then
        echo "faltou o arquivo $keywords"
        exit 2
fi

hardmoburl="https://www.hardmob.com.br/forums/407-Promocoes"

if [ "$1" = "off" ]
then
	exclude="+"
else
	exclude="-"
fi

cat "$apppath/$keywords" | fgrep -v "$exclude" | tr -d "+-" | awk '
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
'
