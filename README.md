# Missive: Linux Server Reporter

Missive is a MIT/X11 licensed bash script for sending basic status reports from a Linux server to an email address. Combine with cron for regular reports.

## Usage

    $ missive.sh bob@example.com

## Example Report

    Uptime: 21:41:23 up 23:51,  1 user,  load average: 0.00, 0.00, 0.00

    Logins:
    bob      pts/0        Tue Apr 15 16:50   still logged in    rdns.example.com
    alice    pts/0        Tue Apr 15 16:46 - 16:48  (00:01)     rdns.example.com
    bob      pts/0        Tue Apr 15 13:02 - 13:03  (00:00)     rdns.example.com

    Updates:

## Dependencies

Missive requires [swaks](http://www.jetmore.org/john/code/swaks/) for sending emails via SMTP.
