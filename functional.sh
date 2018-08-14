#!/bin/bash
THIS_FILE=functional.sh
export THIS_FILE

rf(){
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	require_file $DIR/$THIS_FILE
}
src(){ #sources this file
	source ~/.bashrc
} 
parse_git_branch() { 
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}  

stdout(){
	echo -E "$@" 2>&1 >&1
}
stderr(){
	echo -E "$@" >&2
}

# Forces all output to be piped to stdout
cout(){
	cat - >&1
}

# Forces all output to be piped to stderr
cerr(){ 
	cat - >&2
}

require_file(){
	[ -f $1 ] && { source $1 ; return 0; }
	stderr "FILE NOT FOUND: $1"
	return 1;
}
include_file(){
	[ -f $1 ] && { source $1 ; return 0; }
	return 1;
}

# function: apply <condition> <function> <parameter1> [ ...parameterN ]
#
# Example usage: 
# $ function say_hello(){ echo "hello $1" }
# $ apply $( [ ! -z $USER ] ) say_hello $USER
apply(){ 
	[ $1 ] && { 
		shift
		f=$1
		shift
		$f $@
		return $?
	} 
}
