#!/bin/sh
###############################################################################
# PREREQUISITES: 
# Basics really. A working shell, a few common unix utilities (wget, xwd, fmt,
#	shuf, tail) all of which should be pretty standard. Fortune and cowsay are
#	the only non-standard tools. Both should be available via rpmforge, or the
#	epel extras (I built this on Centos/SL, but should run anywhere.)
#
# NOTES/TROUBLESHOOTING:
# Keep in mind that Openfire runs HTTP on port 9090 and HTTPS on port 9091 by
#	default. If the script is hanging, check that you have matched the port and
#	protocol.
#
# If you're having problems with HTTPS connections, try matching the user-
#	specified SERVERNAME variable with the hostname specified in the server's
#	certificate, especially if you are not using the IGNORETLSCERT option.
#
# HTTPS posting with a verified certificate isn't tested. Mine is self-signed 
#	since all I care about is not sending the password plaintext. It should be
#	just fine if you change the IGNORETLSCERT flag below. 
#
# TODO:
# In the cowsayfortune module we are using the 'which' command to test for
# the availibilty of the fortune and cowsay tools, but we're not leveraging
# the fact that we did so, and as such COULD be creating a situation where
# we have the tool but it's not in the path. Why not load the location into
# a variable and avoid that problem?
#
# I still need to verify the functionality of the HTTPS wget method with a
# full-blown verified certificiate. I'm sure it works, but I haven't tested.
# 
# BUGS:
# I'm sure there are some. I've worked out all that I've found. There's not
#	much to go wrong here, as long as the underlying tools are sound.
###############################################################################

###############################################################################
# SITE SPECIFIC VARIABLES: 
# Edit these to match your location's setup. Defaults should be just fine, and 
#	they work for me, but I setup flags and variables to make the script a bit 
#	more flexible and easier to use on multiple machines. Yes, I know  it is 
#	overengineered. I've been known to do that occasionally. We covered that.
###############################################################################

SERVERNAME=localhost		  # Your server's hostname or IP
SERVERPORT=9091				    # Your Openfire Server's port (http:9090,https:9091)
USEHTTPS=1					      # Use HTTPS (0=http, 1=https)
IGNORETLSCERT=1 			    # Ignore tls certificate validity? (0=no,1=yes)
OFUSERNAME=admin          # Your Openfire user name
OFPASSWORD=S3cr3tW0rd 		# Your Openfire User's password (PLAINTEXT!!)

#### DO NOT EDIT BELOW THIS LINE unless you want to mess with the actual code.

cowsayfortune()
{
###############################################################################
# Adapted from cowsayfortune module of shwelcome package
# Copyright (c) 2013 Curtis K (www.centosblog.com) Used under the MIT license
###############################################################################

check_fortune=$( which fortune 2>/dev/null )
check_cowsay=$( which cowsay 2>/dev/null )
# Do we have fortune?
if [ -n "${check_fortune}" ]
then
	# We have fortune, how about cowsay?
	if [ -n "${check_cowsay}" ]
	then
		# Since we have both, let's run the whole thing.
		{ fortune fortunes | fmt -80 -s | cowsay -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n; }
	else
		# No cowsay, but we can give a fortune anyway
		fortune -l | fmt -80
	fi
else
	# No fortune, no cowsay, Just die (mostly) quietly.
	echo "Sorry, no fortune, no cowsay. All hat, no cattle. Static snark mode on."
fi
}

urlencode() {
###############################################################################
# this urlencode script/module was Copied in full from Chris Down (cdown) 
# at https://gist.github.com/cdown/1163649
###############################################################################

    local length="${#1}"
    for (( i = 0; i < length; i++ ))
	do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%s' "$c" | xxd -p -c1 |
                   while read c; do printf '%%%s' "$c"; done ;;
        esac
    done
}
# Main script begins here

# First, we use the cowsayfortune module to generate a phrase
cowsayfortune > /tmp/phrase_motd
# You can append anything  you want at this point, maybe a REAL motd file?

# Then we "URL Percent Encode" the file we created
urlencode "`cat /tmp/phrase_motd`" > /tmp/phrase_motd_urlencode

# Now we load it into a variable to pass to the wget sequence
PHRASE=`cat /tmp/phrase_motd_urlencode`

# Now let's feed it to the server.
if [ "$USEHTTPS" -eq 0 ]			# Are we using Plain Old HTTP? (USEHTTPS=0)
then
	wget --cookies=on --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="url=/index.jsp&login=true&username=$OFUSERNAME&password=$OFPASSWORD" http://"$SERVERNAME":"$SERVERPORT"/login.jsp -O /dev/null 2>&1 1>/dev/null 2>/dev/null
	wget --cookies=on --load-cookies=/tmp/cookies.txt --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="propName=plugin.motd.message&propValue="$PHRASE"&save=Guardar+Propiedad" http://"$SERVERNAME":"$SERVERPORT"/server-properties.jsp -O /dev/null 2>&1 1>/dev/null 2>/dev/null
elif [ "$IGNORETLSCERT" -eq 1 ]		# TLS w/unverified certificate?
then
	wget  --no-check-certificate --cookies=on --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="url=/index.jsp&login=true&username=$OFUSERNAME&password=$OFPASSWORD" https://"$SERVERNAME":"$SERVERPORT"/login.jsp  -O /dev/null 2>&1 1>/dev/null 2>/dev/null
	wget --no-check-certificate --cookies=on --load-cookies=/tmp/cookies.txt --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="propName=plugin.motd.message&propValue="$PHRASE"&save=Guardar+Propiedad" https://"$SERVERNAME":"$SERVERPORT"/server-properties.jsp -O /dev/null 2>&1 1>/dev/null 2>/dev/null
else				# Must be full-bore https w/signed certificate.
	wget --cookies=on --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="url=/index.jsp&login=true&username=$OFUSERNAME&password=$OFPASSWORD" https://"$SERVERNAME":"$SERVERPORT"/login.jsp  -O /dev/null 2>&1 1>/dev/null 2>/dev/null
	wget --cookies=on --load-cookies=/tmp/cookies.txt --keep-session-cookies --save-cookies=/tmp/cookies.txt --post-data="propName=plugin.motd.message&propValue="$PHRASE"&save=Guardar+Propiedad" https://"$SERVERNAME":"$SERVERPORT"/server-properties.jsp -O /dev/null 2>&1 1>/dev/null 2>/dev/null
fi

# Let's clean up our mess...errors to bitbucket and -f to avoid the unix nanny
rm -f /tmp/phrase_motd /tmp/phrase_motd_urlencode 2> /dev/null

# We're the strong, silent type, but we can at least acknowledge our operator.
echo "Openfire MOTD Script complete."
exit 0					# Why? Well, we useta hafta. No harm in it.

