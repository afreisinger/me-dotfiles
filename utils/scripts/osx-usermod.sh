#!/bin/sh
# osx-usermod --- add, remove, or tweak user accounts on OSX
# Author: Noah Friedman <friedman@splode.com>
# Created: 2011-08-04
# Public domain

# $Id: osx-usermod,v 1.3 2017/12/31 05:44:03 friedman Exp $

# Commentary:
# Code:

nextuid()
{
    max=`dscl . -list /Users UniqueID | sort -ug -k2,2 | sed -ne '${s/^.* //p;}'`
    echo $(($max + 1))
}

useradd()
{
      user=$1
    passwd=$2
       uid=${3:-`nextuid`}
       gid=${4:-20}
     gecos=$5
      home=${6:-/Users/$user}
     shell=${7:-/bin/bash}

    dscl . create /Users/$user
    dscl . passwd /Users/$user                  "$passwd"
    dscl . create /Users/$user UniqueID         "$uid"
    dscl . create /Users/$user PrimaryGroupID   "$gid"
    dscl . create /Users/$user RealName         "$gecos"
    dscl . create /Users/$user NFSHomeDirectory "$home"
    dscl . create /Users/$user UserShell        "$shell"

    case $home in
        /Users/* )
            if ! [ -d "$home" ]; then
                createhomedir -c -u $user
            fi ;;
    esac
}

adminuseradd()
{
    useradd "$@"

    admin_groups="admin _lpadmin _appserveradm _appserverusr"
    for group in $admin_groups; do
        dscl . append /Groups/$group GroupMembership $user
    done
}

userdel()
{
    user=$1

    for group in `dscl . list /Groups`; do
        dscl . delete /Groups/$group GroupMembership $user 2> /dev/null
    done

    dscl . delete /Users/$user
}

userhide()
{
    for user in "$@"; do
        dscl . create /Users/$user IsHidden 1
    done
}

userunhide()
{
    for user in "$@"; do
        dscl . delete /Users/$user IsHidden
    done
}

######
##
######

usage()
{
    progname=${0##*/}

    exec 1>&2
    case $# in
        0 ) : ;;
        * ) echo $progname: "$@"; echo ;;
    esac

    echo "\
Usage: $progname add  {-admin} [username] [passwd] [uid] [gid] {gcos} {homedir} {shell}
       $progname del           [username]
       $progname hide          [username]
"
    exit 1
}

cmd_add()
{
    cmd=useradd
    case $1 in
        -admin ) cmd=admin$cmd ; shift ;;
    esac

    case $# in
        [0-4] ) usage ;;
    esac

    $cmd "$@"
}

cmd_del()
{
    case $# in
        1 ) userdel "$@" ;;
        * ) usage ;;
    esac
}

cmd_hide()   { userhide   "$@"; }
cmd_unhide() { userunhide "$@"; }

main()
{
    case $1 in
        add | del | hide | unhide ) cmd=$1; shift; cmd_$cmd "$@" ;;
        * ) usage ;;
    esac
}

main "$@"

# eof
