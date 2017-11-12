#!/usr/bin/env bash

function PACKAGE_NAME ()
{
	PACKAGE_PRE_RUN

	PACKAGE_RUN "${@}"
}

if [[ ${BASH_SOURCE[0]} != ${0} ]]
then
	export -f PACKAGE_NAME
else
	PACKAGE_NAME "${@}"
	exit ${?}
fi
