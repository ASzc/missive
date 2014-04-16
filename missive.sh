#!/bin/bash

#
# Copyright 2014 Alex Szczuczko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

set -e
set -u

#
# Setup
#

die() {
    echo "$@" >&2
    exit 1
}

inpath() {
    which "$1" 1>/dev/null 2>&1
}
require() {
    inpath "$1" || die "$1 is required"
}

require swaks

#
# Config
#

[ "$#" -eq 1 ] || die "Wrong number of arguments"

addressee="$1"

#
# Collect message components
#

host_fqdn="$(hostname -f)"

start_time="$(date -Iminutes)"

uptime="$(uptime)"

if inpath yum
then
    updates_list="$(yum -q list updates | sed -r -e 's/^([^.]+)\.(.i386|.i686|.x86_64|.noarch|.src) +([^ ]+)\.el.*$/\1 \3/;tx;d;:x' | column -t)"
else
    updates_list="[System not supported]"
fi

login_list="$(last -ad -n3 | grep -v -e '^wtmp begins' -e '^$')"

#
# Send message
#

{
    printf 'Uptime:%s\n\n' "$uptime"
    printf 'Logins:\n%s\n\n' "$login_list"
    printf 'Updates:\n%s\n' "$updates_list"
} | swaks --to "$addressee" --from "missive@$host_fqdn" --header "Subject: Status of $host_fqdn at $start_time" --body - >latest-message 2>&1
