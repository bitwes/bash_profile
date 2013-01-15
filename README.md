#Define a place for all my customizations to live so that they can coexist
#with other profiles.
#
#When this loads it will load pre_local then main then post_local so that 
#changes can be made to the profile that are specific to each location but
#cannot be used everywhere.

#--------------------------------------
#load all my common stuff
BASHFILES=~/butch_bash_profile
export BASHFILES
if [ -f $BASHFILES/includes ]; then
    . $BASHFILES/includes
fi
#--------------------------------------