**PREREQUISITES:**

Basics really. A working shell, a working PERL, a few common unix utilities (wget, xwd, fmt, shuf, tail) all of which should 
be pretty standard. Fortune and cowsay are the only non-standard tools. Both should be available via rpmforge, or the epel extras, 
or any of a number of places. Fortune's been around long enough to get a senior discount at Denny's and Cowsay has been out there 
since at least 1999. I can't lay my hands on the source right now, but it is out there.  (I built this on Centos/SL, but it should 
run anywhere.)

**INSTALLATION and USAGE:**

1. Unpack the files into the directory of your choosing:

`tar -xfvz {filename.tgz}`

2. Edit the main script file (of_motd_update.sh) and update the user-specific variables to match your site. Note that if you're 
   using HTTP (not preferred, since we pass the UserID and Password in the URL) you'll want to point to port 9090. If the server 
   has a verified certificate you can change the IGNORETLS flag to "0" for fully operable TLS/HTTPS connectivity.

3. Verify that you can execute the script 

`chmod +x of_motd_update.sh`

4. Execute the script! 

`./of_motd_update.sh`

**NOTES/TROUBLESHOOTING:**

1. Keep in mind that Openfire runs HTTP on port 9090 and HTTPS on port 9091 by default. If the script is hanging, check that you 
   have matched the port to the protocol.

2. If you're having problems with HTTPS connections, try matching the user- specified SERVERNAME variable with the hostname 
   specified in the server's certificate, especially if you are not using the IGNORETLSCERT option.

3. HTTPS posting with a verified certificate isn't tested. Mine is self-signed since all I care about is not sending the password 
   plaintext. It should be just fine if you change the IGNORETLSCERT flag below. 

4. You may want to run the script via the cron scheduler. I just dropped it into my /etc/cron.hourly directory and let it go. Note
   that the script does produce a line of output, and as such (unless you configure it otherwise) you'll get an email from cron
   every time that the script runs. This may or may not be desirable behavior. You can either remove the output from the script
   or configure cron not to email you if you wish to stop the emails.

**TODO:**

1. In the cowsayfortune module we are using the 'which' command to test for the availibilty of the fortune and cowsay tools, but 
   we're not leveraging the fact that we did so, and as such COULD be creating a situation where we have the tool but it's not in 
   the path. Why not load the location into a variable and avoid that problem?

1. I still need to verify the functionality of the HTTPS wget method with a  full-blown verified certificiate. I'm sure it works, 
   but I haven't tested.
 
**BUGS:**

I'm sure there are some. I've worked out all that I've found. There's not much to go wrong here, as long as the underlying tools 
are sound.

I've only tested it on a Scientific Linux (Centos/Fedora/RedHat) 6.7 system, but I can't see any reason it won't run just fine 
on any machine with fortune. You'll need cowsay for the whole package, but it'll run just fine without it.

I know it's not much of an install document, and I'll update it at some point. This should be enough to get you started anyway!


