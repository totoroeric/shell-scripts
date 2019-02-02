#!/bin/sh

set -x
#set -v
#or you can just use echo to do some debug output
#or using debug level like below
#debug level can be more than one levels
#for example
#debug=2
#test $debug -gt 0 && echo "A little data"
#test $debug -gt 1 && echo "Some more data"
#test $debug -gt 2 && echo "Even some more data"

#you also can use alert function to protect cirtical step of your script

alert(){
	local RET_CODE=$?
	if [ -z "$DEBUG" ] || [ "$DEBUG" -eq 0 ]; then
		return
	fi
	if [ "$RET_CODE" -ne 0 ]; then
		echo "Warn: $* failed with a return code of $RET_CODE." >&2
		[ "$DEBUG" -gt 9 ] && exit "$RET_CODE"
		[ "$STEP_THROUGH" -eq 1 ] && { echo "Press [Enter] to continue" >&2; read x }
	fi
	[ "$STEP_THROUGH" -eq 2 ] && { echo "Press [Enter] to continue" >&2; read x } 
}
debug=1

echo -n "Can you write device drivers? "
read answer
answer=$(echo $answer | tr [a-z] [A-Z])
if [ $answer == Y ];then
	alert("input read ")
	echo "Wow, you must be wery skilled"
	test $debug -gt 0 && echo "The answer is $answer"
else
	echo "Neither can I, I am just an example shell script"
	test $debug -gt 0 && echo "The answer is $answer"
fi


	

