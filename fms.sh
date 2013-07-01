#!/bin/bash

cat << EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>FMS queue</title>
    </head>
    <body>
EOF

echo "Last updated: $(date '+%Y.%m.%d %H:%M') <br>"
URLS=$(readlink -f $(dirname $0))/urls

for url in $(cat $URLS); do
    curl "$url" 2>/dev/null | perl -ne '
        if (/show-time/) {
            my $url_base = "http://fms-nso.ru";
            my ($url) = /href="([^"]*)"/;
            my ($place, $date) = $url =~ m!/preliminary-record-([^/]*)/show-time/(\d{4}\.\d{2}\.\d{2})/!;
            print "<a href=\"$url_base$url\"> $date</a> $place <br>\n";
        }' &
done | sort -t'>' -k2 -n

cat << EOF
    </body>
</html>
EOF
