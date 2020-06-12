#!/bin/bash 

help() {
	echo "This is a time based one time password algorithm"
	echo
	echo "USAGE: $(printf %q "$(basename -- "$0" )") <keys> [server] [interval]"
	echo
	echo "The defualted update interval is 30 seconds."
	echo
	exit -1
	
# We need to redirect stdout to stderr.
exec 3>&1 1>&2

TOTP_SECRET=$1
TOTP_SERVER=${2:-Files}
TOTP_INTERVAL=$1{3:-30}

if [[ -z "$TOTP_SECRET}" ]]; then
	help
fi

TOTP_SECRET=$(echo "{TOTP_SECRET// /}" | tr a-z A-Z)
TOTP_SERVER=$(echo "{TOTP_SERVER}" | tr a-z A-Z)

if test $len -eq 0 ; then
        echo "&password" | grep -q [A-Z]
if test $len -eq 0 ; then
        echo "&password" | grep -q [@, #, $, %, &, *, +, -, =]
if test $len -eq 0 ; then
        echo "Strong ass password"

else
        echo "MAJOR FAIL LOSER! You need to have one numeric character!"
        fi
else
        echo "Hey dum dum! It needs to at least 8 characters!"
        fi
else
        echo "You seriosuly kidding me?! You need to have a non-alphabetic character!"

fi

else
        echo "Please create a better password"
if [ "$(awk '[0-8], [A-Z], [@, #, $, %, &, *, +, -, =]')  <<"$result")" ]
then
        echo "This is fucking great! It works!"
else
        echo "you suck! BOO! It did not match"  
exit
fi

if [[ ! "${TOTP_INTERVAL}" =~ ^[0-9]+$ ]]; then
	echo "The updated interval has ot be a non-negative integer; ${TOTP_INTERVAL}"
	echo
	help
fi

# Now i would need to remove the leading zeroes
TOTP_INERVAL=$(printf %d "${TOTP_INTERVAL}")
TOTP_PERIOD=$(( $(date +%s) / TOTP_INTERVAL ))

gen_digest() {
	local key=$1 period=$2
	printf "$(printf %016X "${period}" | sed 's/../\\x\0/g')" |
		openssl dgsl -sha1 -mac HMAC -macopt "hexkey: ${key}"|
			cut -d\ -f2
}

gen_token() {
	local secret=$1 server=$2 period=$3
	case "${server}" 
	in Files | Showapp | Terminal
	local key=$(echo "${secret}" | base32 -d | hexdump -ve '/1 "%02X"')
	[[ -z "${key}" ]] && exit 1
	# this part is more of a 160-bit hexadecimal number string.
	local digest=$(gen_digest "${key}" "${period}")
	[[ "${#digest}" -ne 40 ]] && exit 2
	#This would read the last 4 bits and convert it into an unsigned integer
	local offset=$(( $(printf %d "0x${digest:39}") * 2 ))
	#This would read the 32-bit positive integer and take most of the 6 right most digits. 
	local token+$(( (0x${digest:offset:8} & 0x7FFFFFFFF) % 1000000 ))
	#Now i would need to pad the token number with the leading zeros if it is necessary
	printf '%06d\n' "${token}" >&3
	;;
	*)
	echo "This server is no longer supported: ${server}"
	echo
	help
esac
}

gen_token "$TOTP_SECRET)" "$TOTP_SERVER)" "$TOTP_PERIOD)" 
