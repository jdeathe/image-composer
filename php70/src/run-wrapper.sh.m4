#!/usr/bin/env bash

function WRAPPER_NAME ()
{
	WRAPPER_PRE_RUN

	WRAPPER_RUN "${@}"
}

if [[ ${BASH_SOURCE[0]} != ${0} ]]
then
	export -f WRAPPER_NAME
else
	WRAPPER_NAME "${@}"
	exit ${?}
fi
