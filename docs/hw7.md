# Homework 7 #

## Overview ##

Linux command assignment

## Deliverables ##

### Problem 1 ###

296 words

`wc lorem-ipsum.txt`

![question 1](/assets/hw7/question1.png)

### Problem 2 ###

2089 characters(1 byte = 1 character )

`wc lorem-ipsum.txt`

![question 2](assets/hw7/question1.png)

### Problem 3 ###

20 lines

`wc lorem-ipsum.txt`

![question 3](assets/hw7/question1.png)

### Problem 4 ###

`sort -h file-sizes.txt`

![question 4](assets/hw7/question4.png)

### Problem 5 ###

`sort -hr file-sizes.txt`

![question 5](assets/hw7/question5.png)

### Problem 6 ###

`cut -d',' -f3 log.csv`

![question 6](assets/hw7/question6.png)

### Problem 7 ###

`cut -d',' -f2,3 log.csv`

![question 7](assets/hw7/question7.png)

### Problem 8 ###

`cut -d',' -f1,4 log.csv`

![question 8](assets/hw7/question8.png)

### Problem 9 ###

`head -n 3 gibberish.txt`

![question 9](assets/hw7/question9.png)

### Problem 10 ###

`tail -n 2 gibberish.txt`

![question 10](assets/hw7/question10.png)

### Problem 11 ###

`tail -n +2 log.csv`

![question 11](assets/hw7/question11.png)

### Problem 12 ###

`grep "and" gibberish.txt`

![question 12](assets/hw7/question12.png)

### Problem 13 ###

`grep -wn "we" gibberish.txt`

![question 13](assets/hw7/question13.png)

### Problem 14 ###

`grep -Pio "to \w+" gibberish.txt`

![question 14](assets/hw7/question14.png)

### Problem 15 ###

`grep -o 'FPGAs' fpgas.txt | wc -l`

![question 15](assets/hw7/question15.png)

### Problem 16 ###

`grep -E '\b(hot|not|cower|tower|smile|compile)\b' fpgas.txt`

![question 16](assets/hw7/question16.png)

### Problem 17 ###

`grep -r -c -P '-\-\' --include"*.vhd" hdl` 

Could not get this one to work -- womp womp

![question 17]()

### Problem 18 ###

`ls > ls-output.txt && cat ls-output.txt`

![question 18](assets/hw7/question18.png)

### Problem 19 ###

`sudo dmesg | grep "CPU"`

Could not get This one to work -- womp womp 

![question 19]()

### Problem 20 ###

`find hdl/ -iname '*.vhd' | wc -l`

![question 20](assets/hw7/question20.png)

### Problem 21 ###

` find hdl/ -type f -name '*.vhd' -exec grep -- '--' {} + | wc -l`

![question 21](assets/hw7/question21.png)

### Problem 22 ###

`grep -n "FPGAs" fpgas.txt | cut -d: -f1`

![question 22](assets/hw7/question22.png)

### Problem 23 ###

`du -h --max-depth=1 | sort -hr | head -n 3`

![question 23](assets/hw7/question23.png)

## Questions ##

No other questions were asked for this assignment