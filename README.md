**Openfire_MOTD_Updater**

A script to update Openfire's Message of the Day automatically

Automates the updating of OpenFire's MOTD using fortune and (optional) cowsay. Requires the OpenFire MOTD plugin. It allows for
HTTPS or HTTP connections to the OpenFire server, and is easily configurable to run either on the OpenFire server itself, or remotely.

This script can be run on the OpenFire server, or run remotely. 

 *2015-11-16*

 Just like there's nothing new under the sun, there's nothing original about this script. Use it as you will and do with it as you
 please. I would ask	that you respect the rights and roles of the ORIGINAL authors (that's not	me) by giving credit where credit is
 due, as I have attempted to do here.	I'm nothing more than a cobbler and a crude integrator in this endeavor. 

 I did this for fun and entertainment. It started out for me as a simple "Gee, I'd like to have shwelcome's cowsay thing running
 in my MOTD," and grew out of control from there. I thought it should be somewhat portable and robust because I clone and kill 
 a ton of virtual machines, and I don't always set	them up completely. Therefore, all the flags and conditionals. I thought it 
 might be useful for someone else too.

It's worth exactly what you didn't pay for it. It serves as an example of how	convoluted a simple	idea in the wrong hands can
become,and a reminder that there's a point at which your code is over-done and maybe even over-documented. I'sure both lines
are back behind me somwehere, but I sure can't see them!

Enjoy!

 **CREDITS:**
 
The original Openfire MOTD mod came from	"rogi333" here: https://community.igniterealtime.org/docs/DOC-1752 This is the core of the communication with the Openfire server.

The cowsay/fortune script came from CurtisK's shwelcome script, and was located here: https://github.com/centosblog/shwelcome. The shwelcome script is licensed under the MIT license.

The urlencode script came from https://gist.github.com/cdown/1163649 and was	posted by Chris Down (cdown). Getting the whole ASCII art cow thing in place, while staying native sh/bash would have been impossible without this nice piece of scripting genius.
