#!/bin/bash
# for use with t2b to process output
#default to 800x600 but allow override on command line
X=${1:-800}
Y=${2:-600}

# maximum zero-based index
X0=$(($X-1))
Y0=$(($Y-1))

# There are 7 zones (4 black and 3 colors) so figure out the boundaries
X7Width=$(($X/7))
X7WidthR0=$X7Width
X7WidthR1=$(($X7WidthR0+$X7Width))
X7WidthG0=$(($X7WidthR1+$X7Width))
X7WidthG1=$(($X7WidthG0+$X7Width))
X7WidthB0=$(($X7WidthG1+$X7Width))
X7WidthB1=$(($X7WidthB0+$X7Width))


# Macros for t2b and the PPM header which is
# P6\nx\ y\n255\n  
cat <<zzzEOF
macro RED
begin
  u8 255 times 2 u8 0 endtimes
endmacro

macro GREEN
begin
  u8 0 u8 255 u8 0
endmacro

macro BLUE
begin
   times 2 u8 0 endtimes u8 255
endmacro

macro BLACK
begin 
   times 3 u8 0 endtimes
endmacro

macro WHITE
begin
    times 3 u8 255 endtimes
endmacro

strl P6
str $X
u8 32
strl $Y
strl 255
zzzEOF

# Now emit binary RGB triples
for ((iY=0;iY<Y;iY++))  # do all rows
do
      for ((iX=0;iX<X;iX++))  # do a row
      do
# border
	  if [ $iX -eq 0 -o $iY -eq 0 -o $iX -eq $X0 -o $iY -eq $Y0 ]
	  then
	      echo WHITE  # white 1 px border
	  else
# pixels
	      if [ $iX -gt $X7WidthR0 -a $iX -lt $X7WidthR1 ]
	      then
		  echo RED
		  continue
	      fi
	      if [ $iX -gt $X7WidthG0 -a $iX -lt $X7WidthG1 ]
	      then
		  echo GREEN
		  continue
	      fi
	      if [ $iX -gt $X7WidthB0 -a $iX -lt $X7WidthB1 ]
	      then
		  echo BLUE
		  continue
	      fi
	      echo BLACK   # black background
	  fi
      done
done

