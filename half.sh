#!/bin/bash
# use xxd to feed data to stdin
# and xxd -r to process data back out
awk '
# need to find 4 white space fields
BEGIN  { noheader=4 }

    {
    lp=1
    }


    {
    split($0, chars, "")
# skip initial address
    while (chars[lp++]!=":");
    n=0;  # # of bytes read
# get two characters 
    while (n<16 && lp<length(chars)) {
# heuristically two space characters out of xxd ends the hex dump line (ascii follows)
       if (chars[lp] ~ /[ \t\n\r]/) {
          if (chars[++lp] ~ /[ \t\n\r]/) { 
             break; # no need to look at rest of line
          }
       }
       b=chars[lp++] chars[lp++];
       n++;
    # if header then skip white space
    if (noheader>0) {
      if (b=="20" || b=="0a" || b=="0d" || b=="09") noheader--;
    }
    else {
    # if not header than /2
     bn=strtonum("0x" b)/2;
     bs=sprintf("%02x",bn);
     chars[lp-2]=substr(bs,1,1);
     chars[lp-1]=substr(bs,2,1);
    }
  }
# recombine array and print
  p=""
  for (i=1;i<=length(chars);i++) p=p chars[i];
  print p
  }
'
  
